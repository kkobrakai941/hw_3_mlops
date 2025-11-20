# HW 3

- `src/producer.py` — читает CSV и пишет строки в Kafka-топик `transactions` (JSONEachRow).
- `clickhouse/ddl/*` — DDL таблиц и materialized views:
  - `01_kafka_table.sql`: Kafka-engine таблица
  - `02_raw_table_mv.sql`: raw MergeTree + MV из Kafka
  - `03_optimized_table.sql`: оптимизированная MergeTree + MV из raw
- `clickhouse/queries/01_max_category_by_state.sql` — запрос максимальной транзакции по штату.
- `results/result.csv` — итоговый файл.

## Как запустить


**Запустить весь стек**

```bash
docker-compose up --build
```

**Проверяем, что данные попали в ClickHouse**

```bash
docker exec -it hw_3_mlops-clickhouse-1 clickhouse-client
```

```sql
SELECT count() FROM transactions_raw;
SELECT count() FROM transactions_opt;
```

**Выполнить SQL-запрос**

```bash
docker exec -i hw_3_mlops-clickhouse-1 clickhouse-client \
  --query="$(cat clickhouse/queries/01_max_category_by_state.sql) FORMAT CSVWithNames" \
  > results/result.csv
```


