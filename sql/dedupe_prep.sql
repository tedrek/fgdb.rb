-- BEFORE THIS:
-- export contact, donation, and sales to DBF
-- process above DBFs with CASS software
-- use dbf2pg to import into tables:
--    cleanup, dcleanup, and scleanup

-- THIS SCRIPT SHOULD ONLY NEED TO BE RUN ONCE

-- ALTER TABLE sales ADD dupe_key varchar(50);
-- ALTER TABLE donation ADD dupe_key varchar(50);

-- DBFs only handle fieldnames up to 10 chars -- fix this here:
-- BEGIN TRANSACTION;

-- -- ALTER TABLE cleanup RENAME contacttyp TO contacttype;
-- -- ALTER TABLE cleanup RENAME organizati TO organization;
-- -- ALTER TABLE cleanup RENAME preferemai TO preferemail;
-- -- ALTER TABLE cleanup RENAME source_tab TO source_table;

-- ALTER TABLE scleanup RENAME contacttyp TO contacttype;
-- ALTER TABLE scleanup RENAME organizati TO organization;
-- ALTER TABLE scleanup RENAME source_tab TO source_table;

-- ALTER TABLE dcleanup RENAME contacttyp TO contacttype;
-- ALTER TABLE dcleanup RENAME organizati TO organization;
-- ALTER TABLE dcleanup RENAME source_tab TO source_table;

-- COMMIT;

-- -- the import doesn't trim the contents of character field --
-- -- fix this here:
-- BEGIN TRANSACTION;

UPDATE contact SET address = TRIM(address),
    address2 = TRIM(address2),
    adopter = TRIM(adopter),
    build = TRIM(build),
    buyer = TRIM(buyer),
    city = TRIM(city),
    comp4kids = TRIM(comp4kids),
    contacttype = TRIM(contacttype),
    donor = TRIM(donor),
    dupe_key = TRIM(dupe_key),
    email = TRIM(email),
    emailok = TRIM(emailok),
    fax = TRIM(fax),
    faxok = TRIM(faxok),
    firstname = TRIM(firstname),
    grantor = TRIM(grantor),
    lastname = TRIM(lastname),
    mailok = TRIM(mailok),
    member = TRIM(member),
    middlename = TRIM(middlename),
    organization = TRIM(organization),
    phone = TRIM(phone),
    phoneok = TRIM(phoneok),
    preferemail = TRIM(preferemail),
    recycler = TRIM(recycler),
    sortname = TRIM(sortname),
--    source_table = TRIM(source_table),
    state = TRIM(state),
    volunteer = TRIM(volunteer),
    waiting = TRIM(waiting),
    zip = TRIM(zip);
-- 
-- UPDATE cleanup SET address = TRIM(address),
--     address2 = TRIM(address2),
--     adopter = TRIM(adopter),
--     build = TRIM(build),
--     buyer = TRIM(buyer),
--     city = TRIM(city),
--     comp4kids = TRIM(comp4kids),
--     contacttype = TRIM(contacttype),
--     donor = TRIM(donor),
--     dupe_key = TRIM(dupe_key),
--     email = TRIM(email),
--     emailok = TRIM(emailok),
--     fax = TRIM(fax),
--     faxok = TRIM(faxok),
--     firstname = TRIM(firstname),
--     grantor = TRIM(grantor),
--     lastname = TRIM(lastname),
--     mailok = TRIM(mailok),
--     member = TRIM(member),
--     middlename = TRIM(middlename),
--     organization = TRIM(organization),
--     phone = TRIM(phone),
--     phoneok = TRIM(phoneok),
--     preferemail = TRIM(preferemail),
--     recycler = TRIM(recycler),
--     sortname = TRIM(sortname),
--     source_table = TRIM(source_table),
--     state = TRIM(state),
--     volunteer = TRIM(volunteer),
--     waiting = TRIM(waiting),
--     zip = TRIM(zip);
-- 
-- UPDATE scleanup SET address = TRIM(address),
--     address2 = TRIM(address2),
--     city = TRIM(city),
--     contacttype = TRIM(contacttype),
--     dupe_key = TRIM(dupe_key),
--     email = TRIM(email),
--     emailok = TRIM(emailok),
--     firstname = TRIM(firstname),
--     lastname = TRIM(lastname),
--     mailok = TRIM(mailok),
--     middlename = TRIM(middlename),
--     organization = TRIM(organization),
--     phone = TRIM(phone),
--     phoneok = TRIM(phoneok),
--     sortname = TRIM(sortname),
--     source_table = TRIM(source_table),
--     state = TRIM(state),
--     zip = TRIM(zip);
-- 
-- UPDATE dcleanup SET address = TRIM(address),
--     address2 = TRIM(address2),
--     city = TRIM(city),
--     contacttype = TRIM(contacttype),
--     dupe_key = TRIM(dupe_key),
--     email = TRIM(email),
--     emailok = TRIM(emailok),
--     firstname = TRIM(firstname),
--     lastname = TRIM(lastname),
--     mailok = TRIM(mailok),
--     middlename = TRIM(middlename),
--     organization = TRIM(organization),
--     phone = TRIM(phone),
--     phoneok = TRIM(phoneok),
--     sortname = TRIM(sortname),
--     source_table = TRIM(source_table),
--     state = TRIM(state),
--     zip = TRIM(zip);
-- 
-- COMMIT;
-- 
-- -- empty fields may not be null and should be --
-- -- fix this here:
-- BEGIN TRANSACTION;
-- 
UPDATE contact SET address = NULL WHERE address = '';
UPDATE contact SET address2 = NULL WHERE address2 = '';
-- UPDATE contact SET city = NULL WHERE city = '';
UPDATE contact SET contacttype = NULL WHERE contacttype = '';
UPDATE contact SET dupe_key = NULL WHERE dupe_key = '';
UPDATE contact SET email = NULL WHERE email = '';
UPDATE contact SET emailok = NULL WHERE emailok = '';
UPDATE contact SET firstname = NULL WHERE firstname = '';
UPDATE contact SET lastname = NULL WHERE lastname = '';
UPDATE contact SET mailok = NULL WHERE mailok = '';
UPDATE contact SET middlename = NULL WHERE middlename = '';
UPDATE contact SET organization = NULL WHERE organization = '';
UPDATE contact SET phone = NULL WHERE phone = '';
UPDATE contact SET phoneok = NULL WHERE phoneok = '';
UPDATE contact SET sortname = NULL WHERE sortname = '';
UPDATE contact SET state = NULL WHERE state = '';
UPDATE contact SET zip = NULL WHERE zip = '';

UPDATE dcleanup SET address = NULL WHERE address = '';
UPDATE dcleanup SET address2 = NULL WHERE address2 = '';
UPDATE dcleanup SET city = NULL WHERE city = '';
UPDATE dcleanup SET contacttype = NULL WHERE contacttype = '';
UPDATE dcleanup SET dupe_key = NULL WHERE dupe_key = '';
UPDATE dcleanup SET email = NULL WHERE email = '';
UPDATE dcleanup SET emailok = NULL WHERE emailok = '';
UPDATE dcleanup SET firstname = NULL WHERE firstname = '';
UPDATE dcleanup SET lastname = NULL WHERE lastname = '';
UPDATE dcleanup SET mailok = NULL WHERE mailok = '';
UPDATE dcleanup SET middlename = NULL WHERE middlename = '';
UPDATE dcleanup SET organization = NULL WHERE organization = '';
UPDATE dcleanup SET phone = NULL WHERE phone = '';
UPDATE dcleanup SET phoneok = NULL WHERE phoneok = '';
UPDATE dcleanup SET sortname = NULL WHERE sortname = '';
UPDATE dcleanup SET source_table = NULL WHERE source_table = '';
UPDATE dcleanup SET state = NULL WHERE state = '';
UPDATE dcleanup SET zip = NULL WHERE zip = '';

UPDATE scleanup SET address = NULL WHERE address = '';
UPDATE scleanup SET address2 = NULL WHERE address2 = '';
UPDATE scleanup SET city = NULL WHERE city = '';
UPDATE scleanup SET contacttype = NULL WHERE contacttype = '';
UPDATE scleanup SET dupe_key = NULL WHERE dupe_key = '';
UPDATE scleanup SET email = NULL WHERE email = '';
UPDATE scleanup SET emailok = NULL WHERE emailok = '';
UPDATE scleanup SET firstname = NULL WHERE firstname = '';
UPDATE scleanup SET lastname = NULL WHERE lastname = '';
UPDATE scleanup SET mailok = NULL WHERE mailok = '';
UPDATE scleanup SET middlename = NULL WHERE middlename = '';
UPDATE scleanup SET organization = NULL WHERE organization = '';
UPDATE scleanup SET phone = NULL WHERE phone = '';
UPDATE scleanup SET phoneok = NULL WHERE phoneok = '';
UPDATE scleanup SET sortname = NULL WHERE sortname = '';
UPDATE scleanup SET source_table = NULL WHERE source_table = '';
UPDATE scleanup SET state = NULL WHERE state = '';
UPDATE scleanup SET zip = NULL WHERE zip = '';

COMMIT;

-- update addresses from cleanup, dcleanup, and scleanup
--    into contact, donation, and sales
BEGIN TRANSACTION;

UPDATE contact SET address = cleanup.address,
    address2 = cleanup.address2,
    bar_chr = cleanup.bar_chr,
    city = cleanup.city,
    contacttype = cleanup.contacttype,
    email = cleanup.email,
    firstname = cleanup.firstname,
    lastname = cleanup.lastname,
    middlename = cleanup.middlename,
    organization = cleanup.organization,
    phone = cleanup.phone,
    state = cleanup.state,
    zip = cleanup.zip FROM cleanup WHERE contact.id = cleanup.id;

UPDATE sales SET address = scleanup.address,
    address2 = scleanup.address2,
    bar_chr = scleanup.bar_chr,
    city = scleanup.city,
    contacttype = scleanup.contacttype,
    email = scleanup.email,
    firstname = scleanup.firstname,
    lastname = scleanup.lastname,
    middlename = scleanup.middlename,
    organization = scleanup.organization,
    phone = scleanup.phone,
    state = scleanup.state,
    zip = scleanup.zip FROM scleanup WHERE sales.id = scleanup.id;

UPDATE donation SET address = dcleanup.address,
    address2 = dcleanup.address2,
    bar_chr = dcleanup.bar_chr,
    city = dcleanup.city,
    contacttype = dcleanup.contacttype,
    email = dcleanup.email,
    firstname = dcleanup.firstname,
    lastname = dcleanup.lastname,
    middlename = dcleanup.middlename,
    organization = dcleanup.organization,
    phone = dcleanup.phone,
    sortname = dcleanup.sortname,
    state = dcleanup.state,
    zip = dcleanup.zip FROM dcleanup WHERE donation.id = dcleanup.id;

COMMIT;

-- contact type is often wrong -- some safe adjustments should be performed:
BEGIN TRANSACTION;

UPDATE contact 
    SET contacttype = 'O' 
    WHERE organization IS NOT NULL 
    AND firstname IS NULL 
    AND middlename IS NULL 
    AND lastname IS NULL 
    AND contacttype = 'P';
UPDATE contact 
    SET contacttype = 'P' 
    WHERE organization IS NULL 
    AND contacttype = 'O';

UPDATE sales 
    SET contacttype = 'O' 
    WHERE organization IS NOT NULL 
    AND firstname IS NULL 
    AND middlename IS NULL 
    AND lastname IS NULL 
    AND contacttype = 'P';
UPDATE sales 
    SET contacttype = 'P' 
    WHERE organization IS NULL 
    AND contacttype = 'O';

UPDATE donation 
    SET contacttype = 'O' 
    WHERE organization IS NOT NULL 
    AND firstname IS NULL 
    AND middlename IS NULL 
    AND lastname IS NULL 
    AND contacttype = 'P';
UPDATE donation 
    SET contacttype = 'P' 
    WHERE organization IS NULL 
    AND contacttype = 'O';

COMMIT;

-- populate sortname field:
--    if contacttype = 'O':
--        UPPER( organization )
BEGIN TRANSACTION;

UPDATE contact 
    SET sortname = SUBSTR( UPPER( organization ), 0, 25 ) 
    WHERE contacttype = 'O';
UPDATE sales 
    SET sortname = SUBSTR( UPPER( organization ), 0, 25)
    WHERE contacttype = 'O';
UPDATE donation 
    SET sortname = SUBSTR( UPPER( organization ), 0, 25 )
    WHERE contacttype = 'O';

--    if contacttype = 'P':
--        TRIM( UPPER( 
--            COALESCE(lastname, '') || 
--            COALESCE(' ' || middlename, '') || 
--            COALESCE(' ' || firstname, '')
--        ))
UPDATE contact SET sortname = 
    SUBSTR( TRIM( UPPER( 
        COALESCE(lastname, '') || 
        COALESCE(' ' || firstname, '') || 
        COALESCE(' ' || middlename, '')
    )), 0, 25 )
    WHERE contacttype = 'P';
UPDATE sales SET sortname = 
    SUBSTR( TRIM( UPPER( 
        COALESCE(lastname, '') || 
        COALESCE(' ' || middlename, '') || 
        COALESCE(' ' || firstname, '')
    )), 0, 25 )
    WHERE contacttype = 'P';
UPDATE donation SET sortname = 
    SUBSTR( TRIM( UPPER( 
        COALESCE(lastname, '') || 
        COALESCE(' ' || middlename, '') || 
        COALESCE(' ' || firstname, '')
    )), 0, 25 )
    WHERE contacttype = 'P';

COMMIT;
