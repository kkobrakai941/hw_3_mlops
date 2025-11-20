DROP TABLE IF EXISTS transactions_opt;

CREATE TABLE transactions_opt
(
    transaction_time DateTime,
    merch LowCardinality(String),
    cat_id LowCardinality(String),
    amount Decimal(12, 2),
    name_1 String,
    name_2 String,
    gender LowCardinality(String),
    street String,
    one_city LowCardinality(String),
    us_state LowCardinality(String),
    post_code UInt32,
    lat Float64,
    lon Float64,
    population_city UInt32,
    jobs LowCardinality(String),
    merchant_lat Float64,
    merchant_lon Float64,
    target UInt8,

    INDEX amount_mm amount TYPE minmax GRANULARITY 1
)
ENGINE = MergeTree
PARTITION BY toYYYYMM(transaction_time)
ORDER BY (us_state, amount);

DROP VIEW IF EXISTS mv_transactions_opt;

CREATE MATERIALIZED VIEW mv_transactions_opt
TO transactions_opt
AS
SELECT
    transaction_time,
    merch,
    cat_id,
    toDecimal64(amount, 2) AS amount,
    name_1,
    name_2,
    gender,
    street,
    one_city,
    us_state,
    post_code,
    lat,
    lon,
    population_city,
    jobs,
    merchant_lat,
    merchant_lon,
    target
FROM transactions_raw;
