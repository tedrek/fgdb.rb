-- 111 is placeholder for keeper
-- 222 is placeholder for tosser

SELECT * FROM contacts WHERE id IN (111, 222);
SELECT 'Merging...';

-- merge contact number 111 into contact number 222
BEGIN;
UPDATE volunteer_tasks SET contact_id = 111 WHERE contact_id = 222;
UPDATE volunteer_hours_worked SET contact_id = 111 WHERE contact_id = 222;
UPDATE donations SET contact_id = 111 WHERE contact_id = 222;
UPDATE sales SET contact_id = 111 WHERE contact_id = 222;
-- note mis-spelling of disbursements:
UPDATE disbursements SET contact_id = 111 WHERE contact_id = 222;
DELETE FROM contacts WHERE id = 222;
COMMIT;

SELECT 'Done merging:';
SELECT * FROM contacts WHERE id IN (111, 222);
