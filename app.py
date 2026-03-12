"""
CloudEngine Labs - Flask REST API

"""

from flask import Flask, jsonify

app = Flask(__name__)


@app.route("/")
def hello():
    return jsonify(message="Hello CloudEngine Labs - from Python Flask!")


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
