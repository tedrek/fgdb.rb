BEGIN TRANSACTION;

UPDATE contact 
    SET dupe_key = SUBSTR( zip || sortname, 0, 50);

COMMIT;

