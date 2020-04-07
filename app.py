from flask import Flask

app = Flask(__name__)


@app.route('/healthcheck')
def healthcheck():
    return "healthy"


@app.route('/api')
def hello():
    return "Hello World!"

if __name__ == '__main__':
    app.run('0.0.0.0', 5000)
