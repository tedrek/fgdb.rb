UPDATE gizmostatuschanges SET created = (SELECT created FROM
gizmo WHERE gizmostatuschanges.id = gizmo.id) WHERE oldstatus =
'None';
