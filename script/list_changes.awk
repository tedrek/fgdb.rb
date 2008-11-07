BEGIN{
    going=true;
    split(blah, a, ",");
}

/^r[0-9]+ .* line$/{
    for(i in a)
        if(i == $1)
            going=false
}

/^-----------/{
    going=true
}

{
    if(going == true)
        print;
}
