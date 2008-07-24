-- get a broad range of dates and how many volunteers were
-- "active" on those dates. "active" is defined as having logged
-- 4 or more hours within the last ninety days

-- NOTE: this doesn't pull every day -- only the days on which
-- work was performed
SELECT 
  date_performed, 
  (SELECT count( distinct zzz.contact_id )
    FROM volunteer_tasks AS zzz 
    WHERE zzz.contact_id IN (
    SELECT xxx.contact_id 
      FROM volunteer_tasks AS xxx 
      WHERE xxx.date_performed BETWEEN 
        volunteer_tasks.date_performed - 90 AND 
        volunteer_tasks.date_performed 
      GROUP BY xxx.contact_id 
      HAVING SUM(xxx.duration) > 4)) AS yyy 
  FROM volunteer_tasks 
  GROUP BY date_performed 
  ORDER BY 1;
