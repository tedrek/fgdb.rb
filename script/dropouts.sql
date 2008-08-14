-- # SELECT id, description FROM contact_types WHERE description IN
-- ('volunteer','dropout') ORDER BY id;
--   id | description
--  ----+-------------
--    4 | volunteer
--   28 | dropout
-- 

-- look for and fix contacts signed up as volunteers but who
-- never recorded volunteer hours

-- just check to see the problem records:

-- year by year count of volunteer signer-uppers who neve
-- volunteered:
SELECT 
  EXTRACT( YEAR FROM contacts.created_at ), COUNT(*) 
  FROM contacts 
  WHERE contacts.id IN 
  (SELECT contact_id 
    FROM contact_types_contacts 
    WHERE contact_type_id = 4) 
  AND NOT EXISTS 
  (SELECT volunteer_tasks.contact_id 
    FROM volunteer_tasks 
    WHERE volunteer_tasks.contact_id = contacts.id) 
  GROUP BY 1 
  ORDER BY 1;

-- fix the problem

-- change volunteers to dropouts if they haven't volunteered
-- and they signed up before 60 days ago
UPDATE contact_types_contacts 
  SET contact_type_id = 28 
  WHERE contact_type_id = 4
  AND 
    (SELECT created_at 
      FROM contacts 
      WHERE contacts.id = contact_types_contacts.contact_id) < now()::date - 60
  AND NOT EXISTS
  (SELECT volunteer_tasks.contact_id 
    FROM volunteer_tasks 
    WHERE volunteer_tasks.contact_id =
    contact_types_contacts.contact_id)
    ;

