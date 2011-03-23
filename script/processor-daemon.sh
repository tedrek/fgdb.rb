#!/bin/sh

# an init script for this will probably involve using
# start-stop-daemon and it's --background option

# simplest example WORK_SCRIPT:
#
# echo "$@"
# "$SCRIPT" rm "$@"

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
    echo "$@" >/dev/stderr
    exit 1
}

ensure_workdir() {
        if [ -z "$WORKDIR" ]; then
            die "Needs WORKDIR environment variable"
        fi
}

MAX_TIMEOUT=100

case "$MODE" in
    run)
        WORK_SCRIPT="$1"
        export WORK_SCRIPT
        flock -n "$WORKDIR/daemon.lock" -c "$SCRIPT _internal"
        ;;
    _internal)
	exec 2>&1 | tee -a "$WORKDIR/daemon.log"
        echo "$$" > "$WORKDIR/daemon.lock"
        touch "$WORKDIR/filelist"
        while [ "$(wc -l "$WORKDIR/filelist")" != 0 ] || inotifywait -e modify "$WORKDIR/filelist"; do
            cp "$WORKDIR/filelist" "$WORKDIR/.filelist.processing"
            while read LINE; do
                if "$SCRIPT" find "$LINE"; then
                    "$WORK_SCRIPT" "$LINE"
                fi
            done < "$WORKDIR/.filelist.processing"
            rm -f "$WORKDIR/.filelist.processing"
        done
        ;;
    add)
        flock -w $MAX_TIMEOUT "$WORKDIR/filelist" -c "echo \"$@\" >> \"$WORKDIR/filelist\""
        ;;
    find)
        flock -w $MAX_TIMEOUT "$WORKDIR/filelist" -c "grep -q -x \"$@\" \"$WORKDIR/filelist\""
        ;;
    rm)
        flock -w $MAX_TIMEOUT "$WORKDIR/filelist" -c "sed -i \"/^$@\$/ d\" \"$WORKDIR/filelist\""
        ;;
    *)
        die "Unknown mode: $MODE"
        ;;
esac
