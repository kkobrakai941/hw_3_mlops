DROP TABLE IF EXISTS transactions_raw;

CREATE TABLE transactions_raw
(
    transaction_time DateTime,
    merch String,
    cat_id String,
    amount Float64,
    name_1 String,
    name_2 String,
    gender String,
    street String,
    one_city String,
    us_state String,
    post_code UInt32,
    lat Float64,
    lon Float64,
    population_city UInt32,
    jobs String,
    merchant_lat Float64,
    merchant_lon Float64,
    target UInt8
)
ENGINE = MergeTree
ORDER BY tuple();

DROP VIEW IF EXISTS mv_transactions_raw;

CREATE MATERIALIZED VIEW mv_transactions_raw
TO transactions_raw
AS
SELECT *
FROM transactions_kafka;
