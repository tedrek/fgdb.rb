BEGIN TRANSACTION;

UPDATE contact 
    SET dupe_key = NULL
    WHERE char_length(TRIM( bar_chr)) < 14;
UPDATE contact 
    SET dupe_key = bar_chr
    WHERE char_length(TRIM( bar_chr)) = 14;

COMMIT;

