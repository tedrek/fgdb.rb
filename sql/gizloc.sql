-- add support for a location field in the gizmo table

-- change the table structure (can take a while):
ALTER TABLE Gizmo ADD column (location varchar(10));

-- add records to populate the dropdown for that field. 
-- create your own records here patterned after these ones
-- set code to what you want stored in the database
-- set description to what you want displayed to the end user
INSERT INTO codedInfo (codeType, codeLength, code, description, modified, created) VALUES ('Gizmo.location',10,'Free Geek','Free Geek',20040409142613,20040409142613);
INSERT INTO codedInfo (codeType, codeLength, code, description, modified, created) VALUES ('Gizmo.location',10,'Borrowed','Borrowed',20040409142645,20040409142645);
INSERT INTO codedInfo (codeType, codeLength, code, description, modified, created) VALUES ('Gizmo.location',10,'Lost','Lost',20040409142656,20040409142656);

-- add a record to make the gizmo editing screen show the new field as a dropdown widget
INSERT INTO fieldMap (tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES ('Gizmo','location',105,'DROPDOWN','Gizmo.location',NULL,NULL,'Y','N','');

