DROP FUNCTION swap(integer, integer) ;

CREATE FUNCTION swap(integer, integer) RETURNS INTEGER AS ' 
DECLARE
    KEEP_ID ALIAS FOR $1 ;
    TOSS_ID ALIAS FOR $2 ;

BEGIN

UPDATE dupe_sets SET 
    keepid = TOSS_ID, tossid = KEEP_ID 
    WHERE keepid = KEEP_ID AND tossid = TOSS_ID;

RETURN 0 ;

END ;
' LANGUAGE 'plpgsql' ;
