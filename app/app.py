from flask import Flask, jsonify
from prometheus_client import Counter, start_http_server
import threading
import time

app = Flask(__name__)

PRODUCTS = [
    {"id": 1, "name": "T-Shirt", "price": 15.99},
    {"id": 2, "name": "Mug", "price": 9.99},
    {"id": 3, "name": "Sticker Pack", "price": 4.99},
]

@app.route("/")
def home():
    return {"app": "SecureCloudShop", "status": "ok"}

@app.route("/products")
def products():
    return jsonify(PRODUCTS)

REQUEST_COUNT = Counter("securecloudshop_requests_total", "Total app requests")

@app.before_request
def before_request():
    REQUEST_COUNT.inc()

def start_metrics_server():
    start_http_server(9111)
    while True:
        time.sleep(1)

# ✅ Start metrics server even when run by Gunicorn (import-time)
threading.Thread(target=start_metrics_server, daemon=True).start()

if __name__ == "__main__":
    # Only used for local 'python app.py' runs
    app.run(host="0.0.0.0", port=5000)
