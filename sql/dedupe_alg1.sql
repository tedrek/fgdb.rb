-- populate dupe_key field in contact, donation, and sales
--    if bar_chr and sortname are both NOT NULL:
--        SUBSTR( bar_chr || sortname, 0, 25)
--    if bar_chr is NOT NULL and sortname IS NULL:
--        bar_chr
--    if sortname is NOT NULL and bar_chr IS NULL:
--        sortname
BEGIN TRANSACTION;

UPDATE contact 
    SET dupe_key = SUBSTR( bar_chr || sortname, 0, 50)
    WHERE bar_chr IS NOT NULL 
    AND sortname IS NOT NULL;
UPDATE contact 
    SET dupe_key = bar_chr
    WHERE bar_chr IS NOT NULL 
    AND sortname IS NULL;
UPDATE contact 
    SET dupe_key = SUBSTR( sortname, 0, 50)
    WHERE bar_chr IS NULL 
    AND sortname IS NOT NULL;
UPDATE contact 
    SET dupe_key = NULL
    WHERE bar_chr IS NULL 
    AND sortname IS NULL;

COMMIT;

