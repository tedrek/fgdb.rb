BEGIN TRANSACTION;

UPDATE contact 
    SET dupe_key = sortname;

COMMIT;

