-- dedupe contact table:
--    
DROP TABLE dupe_keys;
DROP TABLE dupe_sets;
BEGIN TRANSACTION;
-- 
SELECT 
    dupe_key, MIN(id) AS id, count(*) 
    INTO dupe_keys
    FROM contact 
    GROUP BY 1
    HAVING count(*) > 1
    ORDER BY 1;
SELECT 
    dupe_keys.id AS keepid,
    contact.id AS tossid
    INTO dupe_sets
    FROM dupe_keys 
    LEFT JOIN contact ON dupe_keys.dupe_key = contact.dupe_key
    WHERE contact.id > dupe_keys.id;
--    SELECT merge( keepid, tossid ) FROM dupe_sets;    
COMMIT;
ALTER TABLE dupe_keys OWNER TO fgdb;
ALTER TABLE dupe_sets OWNER TO fgdb;
