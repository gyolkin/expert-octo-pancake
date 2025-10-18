import os

from flask import Flask
from dotenv import load_dotenv
import psycopg2


DB_CONNECTION_TIMEOUT = 3


load_dotenv()
app = Flask(__name__)


def db_check():
    try:
        conn = psycopg2.connect(
            dbname=os.environ.get("DB_NAME"),
            user=os.environ.get("DB_USER"),
            password=os.environ.get("DB_PASSWORD"),
            host=os.environ.get("DB_HOST"),
            port=os.environ.get("DB_PORT"),
            connect_timeout=DB_CONNECTION_TIMEOUT,
        )
        cur = conn.cursor()
        cur.execute("SELECT version();")
        version = cur.fetchone()[0]
        cur.close()
        conn.close()
        return f"OK - Connected to PostgreSQL: {version}"
    except Exception as e:
        return f"DB connection error: {e}"


@app.route("/")
def index():
    return "Hello from Flask + Gunicorn + NGINX!"


@app.route("/health")
def health():
    return "OK"


@app.route("/db")
def db():
    return db_check()


if __name__ == "__main__":
    app.run()
