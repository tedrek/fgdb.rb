BEGIN TRANSACTION;

UPDATE contact 
    SET dupe_key = 
    translate(phone, '
    -/ABCDEFGHIJKLMNOPQRSTUVWXZabcdefghijklmnopqrstuvwxyz[]{}<>:=~`@#$%^&*()_+|\;.,''',
    '');

COMMIT;

