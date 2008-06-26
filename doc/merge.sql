-- merge.sql, merge two contact records, 
-- maintaining all child records in related tables

-- 111 is the id for a keeper
-- 222 is the id for recycler

SELECT '===========================';
SELECT * FROM contacts WHERE id IN (111, 222);
SELECT '===========================';
SELECT 'Merging...', now();
SELECT '===========================';

BEGIN;

UPDATE contact_methods SET contact_id = 111 WHERE contact_id = 222;
UPDATE contact_types_contacts SET contact_id = 111 WHERE contact_id = 222;
UPDATE disbursements SET contact_id = 111 WHERE contact_id = 222;
UPDATE donations SET contact_id = 111 WHERE contact_id = 222;
UPDATE sales SET contact_id = 111 WHERE contact_id = 222;
UPDATE users SET contact_id = 111 WHERE contact_id = 222;
UPDATE volunteer_hours_worked SET contact_id = 111 WHERE contact_id = 222;
UPDATE volunteer_tasks SET contact_id = 111 WHERE contact_id = 222;

DELETE FROM contacts WHERE id = 222;
COMMIT;

SELECT '===========================';
SELECT * FROM contacts WHERE id IN (111, 222);
SELECT 'Done merging:', now();

