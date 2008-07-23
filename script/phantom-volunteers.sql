-- # SELECT id, description FROM contact_types WHERE description IN
-- ('volunteer','dropout') ORDER BY id;
--   id | description
--  ----+-------------
--    4 | volunteer
--   28 | dropout
-- 

-- look for and fix contacts who have recorded volunteer hours
-- but never got their volunteer checkbox checked

-- just check to see the problem records:

-- year by year count of volunteer signer-uppers who neve
-- volunteered:
SELECT 
  EXTRACT( YEAR FROM contacts.created_at ), COUNT(*) 
  FROM contacts 
  WHERE EXISTS 
  (SELECT volunteer_tasks.contact_id 
    FROM volunteer_tasks 
    WHERE volunteer_tasks.contact_id = contacts.id) 
  AND NOT EXISTS
  (SELECT contact_id 
    FROM contact_types_contacts 
    WHERE contact_type_id = 4 AND contact_types_contacts.contact_id = contacts.id) 
  GROUP BY 1 
  ORDER BY 1;

-- fix the problem

-- create a volunteer record for each contact that has
-- logged volunteer hours but does not yet have such a record
INSERT INTO contact_types_contacts 
  (contact_id, contact_type_id)
  SELECT contacts.id, 4 
  FROM contacts 
  WHERE EXISTS 
  (SELECT volunteer_tasks.contact_id 
    FROM volunteer_tasks 
    WHERE volunteer_tasks.contact_id = contacts.id) 
  AND NOT EXISTS
  (SELECT xxx.contact_id 
    FROM contact_types_contacts AS xxx 
    WHERE xxx.contact_type_id = 4 AND xxx.contact_id = contacts.id); 

