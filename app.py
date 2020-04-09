from flask import Flask
import json

app = Flask(__name__)


@app.route('/healthcheck')
def healthcheck():
    return json.dumps({'status': 0})


@app.route('/api')
def hello():
    # request logic goes here
    return json.dumps({'field1': 5, 'field2': "something"})


if __name__ == '__main__':
    app.run('0.0.0.0', 5000)
