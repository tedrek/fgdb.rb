BEGIN TRANSACTION;

UPDATE contact 
    SET dupe_key = NULL
    WHERE char_length(TRIM( bar_chr)) < 14
    OR contacttype = 'O';
UPDATE contact 
    SET dupe_key = bar_chr ||
    UPPER( 
        SUBSTR( COALESCE( firstname, ''), 0, 2 ) || 
        SUBSTR( COALESCE( middlename, ''), 0, 2 ) || 
        SUBSTR( COALESCE( lastname, ''), 0, 2 )
    )
    WHERE char_length(TRIM( bar_chr)) = 14
    AND contacttype = 'P';

COMMIT;

