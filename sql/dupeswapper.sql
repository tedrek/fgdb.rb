DROP TABLE dupe_temp2;
DROP TABLE dupe_temp3;

CREATE TABLE dupe_temp2 AS
SELECT keepid, tossid, 
        MAX(COALESCE(kdonation.created, '2000-01-01')) AS kdonation,
        MAX(COALESCE(kmemberhour.created, '2000-01-01')) AS kmember,
        MAX(COALESCE(ksales.created, '2000-01-01')) AS ksales,
        MAX(COALESCE(tdonation.created, '2000-01-01')) AS tdonation,
        MAX(COALESCE(tmemberhour.created, '2000-01-01')) AS tmember,
        MAX(COALESCE(tsales.created, '2000-01-01')) AS tsales
    FROM dupe_sets 
    LEFT JOIN sales ksales ON dupe_sets.keepid = ksales.contactid
    LEFT JOIN sales tsales ON dupe_sets.tossid = tsales.contactid
    LEFT JOIN donation kdonation ON dupe_sets.keepid = kdonation.contactid
    LEFT JOIN donation tdonation ON dupe_sets.tossid = tdonation.contactid
    LEFT JOIN memberhour kmemberhour ON dupe_sets.keepid = kmemberhour.memberid
    LEFT JOIN memberhour tmemberhour ON dupe_sets.tossid = tmemberhour.memberid
    GROUP BY keepid, tossid;

CREATE TABLE dupe_temp3 AS
SELECT keepid, tossid, 
    CASE WHEN ksales > 
        (CASE WHEN kdonation > kmember THEN kdonation ELSE kmember END) 
    THEN ksales 
    ELSE (CASE WHEN kdonation > kmember THEN kdonation ELSE kmember END) 
    END AS keepdate, 
    CASE WHEN tsales > 
        (CASE WHEN tdonation > tmember THEN tdonation ELSE tmember END) 
    THEN tsales 
    ELSE (CASE WHEN tdonation > tmember THEN tdonation ELSE tmember END) 
    END AS tossdate
    FROM dupe_temp2;

SELECT swap(keepid, tossid) 
    FROM dupe_temp3 
    WHERE tossdate > keepdate;

-- if we process a batch triplicates+ may not be handled
-- correctly, ie:
-- 
-- keep toss
-- 1    2
-- 2    3
-- 
-- 2 would get deleted when the process hit the first row
-- and wouldn't be there when the process hit the second row
-- 
-- there's a better fix for this by ordering the dupe_sets 
-- table properly (by the latest date of keep and toss both, 
-- I think) but for now we do this instead:
--
DELETE FROM dupe_sets 
    WHERE tossid IN (SELECT keepid FROM dupe_sets);
