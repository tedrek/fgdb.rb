BEGIN TRANSACTION;

UPDATE contact 
    SET dupe_key = NULL
    WHERE contacttype = 'O';
UPDATE contact 
    SET dupe_key = SUBSTR( 
        bar_chr || 
        UPPER(TRIM(lastname) || ' ' || SUBSTR( firstname, 0, 2)),
        0, 50) 
    WHERE contacttype = 'P';
COMMIT;

