#!/bin/sh
rm *clean
for i in `dir *xml`; do
    file_type=`file -b $i`
    if [ "$file_type" = "XML 1.0 document text" ]; then
        xmlstarlet val $i >& /dev/null
        exit_code=$?
        if [ $exit_code -ne 0 ]; then
            cat $i | tr -dc [:print:] | xmlstarlet fo > $i.clean
            mv $i.clean $i
        fi
    fi
done

