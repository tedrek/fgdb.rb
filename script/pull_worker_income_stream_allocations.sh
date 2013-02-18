#!/bin/sh

set -e

echo "SELECT income_streams.description, SUM(ROUND(100 * duration))/100 FROM worked_shifts JOIN jobs ON job_id = jobs.id JOIN income_streams ON income_stream_id = income_streams.id WHERE date_performed >= '$1' AND date_performed <= '$2' GROUP BY 1 ORDER BY 1;" | psql fgdb_production
