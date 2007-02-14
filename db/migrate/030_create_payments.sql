CREATE TABLE payments (
    id serial NOT NULL PRIMARY KEY,
    donation_id integer REFERENCES donations,
    sale_txn_id integer REFERENCES sale_txns,
    amount numeric(10,2) DEFAULT 0.0 NOT NULL,
    payment_method_id integer NOT NULL,
    lock_version integer DEFAULT 0 NOT NULL,
    updated_at timestamp with time zone DEFAULT now(),
    created_at timestamp with time zone DEFAULT now(),
    created_by bigint DEFAULT 1 NOT NULL,
    updated_by bigint DEFAULT 1 NOT NULL
);

INSERT INTO payments (
        amount,
        payment_method_id,
        created_at,
        donation_id)
    SELECT 
        CASE
            WHEN money_tendered > 0 THEN money_tendered
            WHEN txn_complete = false OR txn_complete IS NULL THEN reported_required_fee + reported_suggested_fee
            ELSE 0
        END,
        COALESCE(payment_method_id, 5),
        created_at,
        id
    FROM donations;

INSERT INTO payments (
        amount,
        payment_method_id,
        created_at,
        sale_txn_id)
    SELECT 
        CASE
            WHEN money_tendered > 0 THEN money_tendered
            WHEN txn_complete = false OR txn_complete IS NULL THEN reported_amount_due
            ELSE 0
        END,
        COALESCE(payment_method_id, 5),
        created_at,
        id
    FROM sale_txns
    WHERE txn_complete = true;

ALTER TABLE donations DROP COLUMN payment_method_id ;
ALTER TABLE donations DROP COLUMN money_tendered ;
ALTER TABLE sale_txns DROP COLUMN payment_method_id ;
ALTER TABLE sale_txns DROP COLUMN money_tendered ;
