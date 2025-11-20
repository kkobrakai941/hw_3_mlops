import os
import json
import time
import pandas as pd
from kafka import KafkaProducer
from dotenv import load_dotenv
from tqdm import tqdm

load_dotenv()

BOOTSTRAP = os.getenv("KAFKA_BOOTSTRAP_SERVERS", "kafka:9092")
TOPIC = os.getenv("KAFKA_TOPIC", "transactions")
CSV_PATH = os.getenv("CSV_PATH", "/app/data/train.csv")
BATCH_SIZE = int(os.getenv("BATCH_SIZE", "5000"))

def main():
    df = pd.read_csv(CSV_PATH)

    producer = KafkaProducer(
        bootstrap_servers=BOOTSTRAP,
        value_serializer=lambda v: json.dumps(v, ensure_ascii=False).encode("utf-8"),
        linger_ms=50,
        batch_size=1024 * 32,
    )

    total = len(df)
    for start in tqdm(range(0, total, BATCH_SIZE), desc="Sending to Kafka"):
        chunk = df.iloc[start:start + BATCH_SIZE]
        for row in chunk.to_dict(orient="records"):
            producer.send(TOPIC, row)

        producer.flush()
        time.sleep(0.2)

    producer.flush()
    producer.close()
    print(f"Done. Sent {total} rows to topic '{TOPIC}'")

if __name__ == "__main__":
    main()
