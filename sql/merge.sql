DROP FUNCTION merge(integer, integer) ;

CREATE FUNCTION merge(integer, integer) RETURNS INTEGER AS ' 
DECLARE
    KEEPID ALIAS FOR $1 ;
    TOSSID ALIAS FOR $2 ;

-- assume that TOSSID and KEEPID are passed in and available as
-- variables

BEGIN

-- update the children of the duplicate record,
-- pointing them to the keeper record:
UPDATE sales        SET contactid = KEEPID WHERE contactid = TOSSID;
UPDATE donation     SET contactid = KEEPID WHERE contactid = TOSSID;
UPDATE income       SET contactid = KEEPID WHERE contactid = TOSSID;
UPDATE pickups      SET vendorid  = KEEPID WHERE vendorid  = TOSSID;

UPDATE workersqualifyforjobs 
                    SET contactid = KEEPID WHERE contactid = TOSSID;
UPDATE daysoff      SET contactid = KEEPID WHERE contactid = TOSSID;
UPDATE workmonths   SET contactid = KEEPID WHERE contactid = TOSSID;
UPDATE weeklyshifts SET contactid = KEEPID WHERE contactid = TOSSID;
UPDATE workers      SET id =        KEEPID WHERE id        = TOSSID
    AND NOT EXISTS (SELECT * FROM workers WHERE id = KEEPID);

UPDATE memberhour   SET memberid  = KEEPID WHERE memberid  = TOSSID;
UPDATE member       SET id        = KEEPID WHERE id        = TOSSID
    AND NOT EXISTS (SELECT * FROM member WHERE id = KEEPID);

UPDATE contactlist  SET contactid = KEEPID WHERE contactid = TOSSID;
UPDATE borrow       SET contactid = KEEPID WHERE contactid = TOSSID;
UPDATE gizmo        SET inspectorid = 
                                    KEEPID WHERE inspectorid = 
                                                             TOSSID;
UPDATE gizmo        SET adopterid = KEEPID WHERE adopterid = TOSSID;
UPDATE gizmo        SET builderid = KEEPID WHERE builderid = TOSSID;
UPDATE scratchpad   SET contactid = KEEPID WHERE contactid = TOSSID;

-- update fields in the keeper record from values
-- in the duplicate record
--
-- for most fields this may be better left to user interaction
-- but for toggles and NULLs it is pretty simple:
UPDATE contact SET 
    adopter =
        CASE WHEN toss.adopter = ''Y''
        THEN ''Y'' ELSE contact.adopter END,
    build =
        CASE WHEN toss.build = ''Y''
        THEN ''Y'' ELSE contact.build END,
    buyer = 
        CASE WHEN toss.buyer = ''Y'' 
        THEN ''Y'' ELSE contact.buyer END,
    comp4kids =
        CASE WHEN toss.comp4kids = ''Y''
        THEN ''Y'' ELSE contact.comp4kids END,
    donor = 
        CASE WHEN toss.donor = ''Y'' 
        THEN ''Y'' ELSE contact.donor END,
    emailok = 
        CASE WHEN toss.emailok = ''Y'' 
        THEN ''Y'' ELSE contact.emailok END,
    faxok = 
        CASE WHEN toss.faxok = ''Y'' 
        THEN ''Y'' ELSE contact.faxok END,
    grantor =
        CASE WHEN toss.grantor = ''Y''
        THEN ''Y'' ELSE contact.grantor END,
    mailok = 
        CASE WHEN toss.mailok = ''Y'' 
        THEN ''Y'' ELSE contact.member END,
    member = 
        CASE WHEN toss.member = ''Y'' 
        THEN ''Y'' ELSE contact.member END,
    phoneok = 
        CASE WHEN toss.phoneok = ''Y'' 
        THEN ''Y'' ELSE contact.phoneok END,
    preferemail =
        CASE WHEN toss.preferemail = ''Y''
        THEN ''Y'' ELSE contact.preferemail END,
    recycler =
        CASE WHEN toss.recycler = ''Y''
        THEN ''Y'' ELSE contact.recycler END,
    volunteer = 
        CASE WHEN toss.volunteer = ''Y'' 
        THEN ''Y'' ELSE contact.volunteer END,
    waiting = 
        CASE WHEN toss.waiting = ''Y'' 
        THEN ''Y'' ELSE contact.waiting END
        ,
    contacttype = COALESCE( contact.contacttype, toss.contacttype ),
    firstname = COALESCE( contact.firstname, toss.firstname ),
    middlename = COALESCE( contact.middlename, toss.middlename ),
    lastname = COALESCE( contact.lastname, toss.lastname ),
    organization = COALESCE( contact.organization, toss.organization ),
    address = COALESCE( contact.address, toss.address ),
    address2 = COALESCE( contact.address2, toss.address2 ),
    city = COALESCE( contact.city, toss.city ),
    state = COALESCE( contact.state, toss.state ),
    zip = COALESCE( contact.zip, toss.zip ),
    phone = COALESCE( contact.phone, toss.phone ),
    fax = COALESCE( contact.fax, toss.fax ),
    email = COALESCE( contact.email, toss.email ),
    notes = COALESCE( contact.notes, toss.notes ),
    modified = COALESCE( contact.modified, toss.modified ),
    created = COALESCE( contact.created, toss.created ),
    sortname = COALESCE( contact.sortname, toss.sortname ),
    salesid = COALESCE( contact.salesid, toss.salesid ),
    donationid = COALESCE( contact.donationid, toss.donationid ),
    dupe_key = COALESCE( contact.dupe_key, toss.dupe_key ),
    bar_chr = COALESCE( contact.bar_chr, toss.bar_chr ),
    err_num = COALESCE( contact.err_num, toss.err_num ),
    err_mess = COALESCE( contact.err_mess, toss.err_mess )
FROM contact AS toss
WHERE contact.id = KEEPID
AND toss.id = TOSSID ;

-- remove the duplicate record 
DELETE FROM contact WHERE id = TOSSID;
-- DELETE FROM dupe_sets WHERE keepid = KEEPID AND tossid = TOSSID;
RETURN 0 ;
END ;
' LANGUAGE 'plpgsql' ;
