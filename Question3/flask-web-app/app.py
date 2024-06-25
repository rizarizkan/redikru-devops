from flask import Flask, Response
from prometheus_client import Counter, generate_latest, CollectorRegistry, multiprocess, CONTENT_TYPE_LATEST

app = Flask(__name__)

REQUEST_COUNT = Counter('request_count', 'App Request Count', ['endpoint'])

@app.route('/')
def hello_world():
    REQUEST_COUNT.labels('/').inc()
    return 'Hello, Docker!'

@app.route('/metrics')
def metrics():
    registry = CollectorRegistry()
    multiprocess.MultiProcessCollector(registry)
    return Response(generate_latest(registry), mimetype=CONTENT_TYPE_LATEST)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
