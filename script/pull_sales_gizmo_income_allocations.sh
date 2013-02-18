#!/bin/sh

set -e

echo "SELECT EXTRACT(month FROM gizmo_events.occurred_at), EXTRACT(year FROM gizmo_events.occurred_at), gizmo_type_groups.name, sale_types.name, SUM(gizmo_count * unit_price_cents * (100 - percentage) / 100) FROM gizmo_events JOIN gizmo_types ON gizmo_events.gizmo_type_id=gizmo_types.id JOIN gizmo_type_groups_gizmo_types ON gizmo_type_groups_gizmo_types.gizmo_type_id=gizmo_types.id JOIN gizmo_type_groups ON gizmo_type_group_id=gizmo_type_groups.id AND gizmo_type_groups.name LIKE 'Allocation: %' JOIN sales ON sale_id = sales.id JOIN sale_types ON sale_type_id = sale_types.id JOIN discount_percentages ON discount_percentages.id = COALESCE(gizmo_events.discount_percentage_id, sales.discount_percentage_id) WHERE sale_id IS NOT NULL AND gizmo_events.occurred_at >= '2007-01-01' GROUP BY 1, 2, 3, 4;" | psql fgdb_production
