#!/bin/sh
exec ruby `dirname $0`/sql_runner $0 "$@"

SELECT '"' || systems.serial_number || '"',count(DISTINCT system_id) AS system_count,count(*) AS spec_sheet_count, max(spec_sheets.created_at) AS last_created FROM spec_sheets LEFT OUTER JOIN systems ON spec_sheets.system_id = systems.id WHERE systems.serial_number NOT LIKE '(no serial number)' AND systems.serial_number NOT IN (SELECT value FROM generics WHERE usable = 't') GROUP BY 1 HAVING count(*) > 5 ORDER BY system_count desc, spec_sheet_count desc;
