import mysql.connector
import time
import random
from prometheus_client import start_http_server, Summary

# Prometheus metric
WRITE_TIME = Summary('write_time_seconds', 'Time spent writing to MySQL')

def generate_data():
    return {
        "product_name": random.choice(["Laptop", "Phone", "Tablet"]),
        "quantity": random.randint(1, 10)
    }

@WRITE_TIME.time()
def write_to_mysql():
    db = mysql.connector.connect(
        host="mysql-master",
        user="root",
        password="rootpassword",
        database="testdb"
    )
    cursor = db.cursor()
    data = generate_data()
    cursor.execute("INSERT INTO sales (product_name, quantity) VALUES (%s, %s)", (data["product_name"], data["quantity"]))
    db.commit()
    print(f"Inserted: {data}")
    db.close()

if __name__ == "__main__":
    start_http_server(8000)
    while True:
        write_to_mysql()
        time.sleep(1)
