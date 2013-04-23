#!/bin/sh

set -e

SCRIPT="$(readlink -f $0)"
export SCRIPT

if [ -z "$WORKDIR" ]; then
    WORKDIR="$(dirname $SCRIPT)/../tmp/daemon-workdir"
    mkdir -p "$WORKDIR"
    export WORKDIR
fi

MODE="$1"
shift

die() {
    echo "$@" >&2
    exit 1
}

ensure_workdir() {
        if [ -z "$WORKDIR" ]; then
            die "Needs WORKDIR environment variable"
        fi
}

MAX_TIMEOUT=100
# how many seconds to sleep after something fails to sync. assuming this is because a service is down, not because a record is borked...hope that's a good assumption.
BREAK_TIME=10

PARENT_LINE="$LINE"
LINE="$@"
export LINE

case "$MODE" in
    run)
        WORK_SCRIPT="$1"
        export WORK_SCRIPT
        flock -n "$WORKDIR/daemon.lock" -c "$SCRIPT _internal"
        ;;
    take_a_break)
        touch "$WORKDIR/take_a_break"
        ;;
    kill)
        kill $(cat $WORKDIR/daemon.lock )
        ;;
    _internal)
	exec 2>&1 >>"$WORKDIR/daemon.log"
        echo "$$" > "$WORKDIR/daemon.lock"
        touch "$WORKDIR/filelist"
        while [ "$(cat "$WORKDIR/filelist" | wc -l)" != 0 ] || inotifywait -e modify "$WORKDIR/filelist"; do
            cp "$WORKDIR/filelist" "$WORKDIR/.filelist.processing"
            while read LINE; do
                if "$SCRIPT" find "$LINE"; then
		    SUCCESS=0
                    if ! "$WORK_SCRIPT" $LINE; then
			SUCCESS="1"
		    fi
                fi
                if [ "$SUCCESS" != "0" -o -e "$WORKDIR/take_a_break" ]; then
                    echo "Sleeping for $BREAK_TIME seconds because of failure..."
                    sleep $BREAK_TIME
                    rm "$WORKDIR/take_a_break"
                fi
            done < "$WORKDIR/.filelist.processing"
            rm -f "$WORKDIR/.filelist.processing"
        done
        ;;
    add)
        flock -w $MAX_TIMEOUT "$WORKDIR/filelist" -c "$SCRIPT _add"
        ;;
    _add)
        echo "$PARENT_LINE" >> "$WORKDIR/filelist"
        ;;
    find)
        flock -w $MAX_TIMEOUT "$WORKDIR/filelist" -c "$SCRIPT _find"
        ;;
    _find)
        grep -q -x "$PARENT_LINE" "$WORKDIR/filelist"
        ;;
    rm)
        flock -w $MAX_TIMEOUT "$WORKDIR/filelist" -c "$SCRIPT _rm"
        ;;
    _rm)
        sed -i "/^${PARENT_LINE}$/ d" "$WORKDIR/filelist"
        ;;
    *)
        die "Unknown mode: $MODE"
        ;;
esac
