CREATE FUNCTION created_trigger() RETURNS opaque AS '
BEGIN
    NEW.created := ''now'';
    NEW.modified := ''now'';
    RETURN NEW;
END;
' LANGUAGE plpgsql;

CREATE FUNCTION modified_trigger() RETURNS opaque AS '
BEGIN
    NEW.modified := ''now'';
    RETURN NEW;
END;
' LANGUAGE plpgsql;

