BEGIN TRANSACTION;

UPDATE contact 
    SET dupe_key = UPPER(email);

COMMIT;

