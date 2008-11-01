#!/usr/bin/awk -f

BEGIN{
    printf "[";
    first="true"
}

/create_table/{
    gsub("\"", "", $2);
    sub(",", "", $2);
    sub("^", ":", $2);
    if(first == "true")
        first=false;
    else print ",";
    printf $2
}

END{
    print "]"
}
