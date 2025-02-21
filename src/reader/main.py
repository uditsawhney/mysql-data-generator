from flask import Flask
import mysql.connector
import time
from prometheus_client import start_http_server, Summary, Gauge

app = Flask(__name__)
READ_TIME = Summary('read_time_seconds', 'Time spent reading from MySQL')
ROW_COUNT = Gauge('row_count', 'Number of rows in the sales table')

@READ_TIME.time()
def count_rows():
    db = mysql.connector.connect(
        host="mysql-slave",
        user="root",
        password="rootpassword",
        database="testdb"
    )
    cursor = db.cursor()
    cursor.execute("SELECT COUNT(*) FROM sales")
    result = cursor.fetchone()[0]
    db.close()
    return result

@app.route("/")
def index():
    rows = count_rows()
    return f"Rows: {rows}"

if __name__ == "__main__":
    start_http_server(8001)
    app.run(host="0.0.0.0", port=5000)
