BEGIN TRANSACTION;

--remove exact match addresses from sales and donations. (don't remove rows, just address entries).

UPDATE sales 
  SET firstname=NULL, lastname = NULL, middlename=NULL, address=NULL, address2=NULL 
  WHERE contactid IS NOT NULL 
  AND EXISTS (SELECT * 
    FROM contact 
    WHERE (sales.address = contact.address OR (sales.address IS NULL AND contact.address IS NULL)) 
    AND sales.contactid = contact.id 
    AND (sales.address2 = contact.address2 OR (sales.address2 IS NULL AND contact.address2 IS NULL)));

UPDATE donation 
  SET firstname=NULL, lastname = NULL, middlename=NULL, address=NULL, address2=NULL 
  WHERE contactid IS NOT NULL 
  AND EXISTS (SELECT * 
    FROM contact 
    WHERE (donation.address = contact.address OR (donation.address IS NULL AND contact.address IS NULL)) 
    AND donation.contactid = contact.id 
    AND (donation.address2 = contact.address2 OR (donation.address2 IS NULL AND contact.address2 IS NULL)));

--you pick:
COMMIT;
-- ROLLBACK;

-- set these to NULL for consistency:
BEGIN TRANSACTION;
UPDATE contact SET firstname = NULL WHERE firstname = '';
UPDATE contact SET middlename = NULL WHERE middlename = '';
UPDATE contact SET lastname = NULL WHERE lastname = '';
UPDATE contact SET organization = NULL WHERE organization = '';
UPDATE contact SET address = NULL WHERE address = '';
UPDATE contact SET address2 = NULL WHERE address2 = '';
UPDATE sales SET firstname = NULL WHERE firstname = '';
UPDATE sales SET middlename = NULL WHERE middlename = '';
UPDATE sales SET lastname = NULL WHERE lastname = '';
UPDATE sales SET organization = NULL WHERE organization = '';
UPDATE sales SET address = NULL WHERE address = '';
UPDATE sales SET address2 = NULL WHERE address2 = '';
UPDATE donation SET firstname = NULL WHERE firstname = '';
UPDATE donation SET middlename = NULL WHERE middlename = '';
UPDATE donation SET lastname = NULL WHERE lastname = '';
UPDATE donation SET organization = NULL WHERE organization = '';
UPDATE donation SET address = NULL WHERE address = '';
UPDATE donation SET address2 = NULL WHERE address2 = '';

--you pick:
COMMIT;
-- ROLLBACK;

DROP TABLE deduper;

CREATE TABLE deduper AS 
SELECT 
    id,
    waiting,
    member,
    volunteer,
    donor,
    buyer,
    id AS sourceid,
    contacttype,
    firstname,
    middlename,
    lastname,
    organization,
    address,
    address2,
    city,
    state,
    zip,
    phone,
    fax,
    email,
    emailok,
    mailok,
    phoneok,
    faxok,
    modified,
    created,
    sortname,
    preferemail,
    comp4kids,
    recycler,
    grantor,
    build,
    adopter,
    '                                                  ' AS dupe_key,
    'contact ' AS source_table
FROM contact
WHERE (firstname IS NOT NULL OR lastname IS NOT NULL OR organization IS NOT NULL) AND
(address IS NOT NULL OR address2 IS NOT NULL)
UNION SELECT 
    contactid AS id,
    'N' AS waiting,
    'N' AS member,
    'N' AS volunteer,
    'N' AS donor,
    'Y' AS buyer,
    id AS sourceid,
    contacttype,
    firstname,
    middlename,
    lastname,
    organization,
    address,
    address2,
    city,
    state,
    zip,
    phone,
    null AS fax,
    email,
    emailok,
    mailok,
    phoneok,
    null AS faxok,
    modified,
    created,
    sortname,
    null AS preferemail,
    null AS comp4kids,
    null AS recycler,
    null AS grantor,
    null AS build,
    null AS adopter,
    '                                                  ' AS dupe_key,
    'sales   ' AS source_table
FROM sales
WHERE (firstname IS NOT NULL OR lastname IS NOT NULL OR organization IS NOT NULL) AND
(address IS NOT NULL OR address2 IS NOT NULL)
UNION SELECT 
    contactid AS id,
    'N' AS waiting,
    'N' AS member,
    'N' AS volunteer,
    'Y' AS donor,
    'N' AS buyer,
    id AS sourceid,
    contacttype,
    firstname,
    middlename,
    lastname,
    organization,
    address,
    address2,
    city,
    state,
    zip,
    phone,
    null AS fax,
    email,
    emailok,
    mailok,
    phoneok,
    null AS faxok,
    modified,
    created,
    sortname,
    null AS preferemail,
    null AS comp4kids,
    null AS recycler,
    null AS grantor,
    null AS build,
    null AS adopter,
    '                                                  ' AS dupe_key,
    'donation' AS source_table
FROM donation
WHERE (firstname IS NOT NULL OR lastname IS NOT NULL OR organization IS NOT NULL) AND
(address IS NOT NULL OR address2 IS NOT NULL)
ORDER BY id, sourceid;
