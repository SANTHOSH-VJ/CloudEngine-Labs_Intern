"""
CloudEngine Labs - Flask REST API
A simple microservice returning a JSON greeting.
"""

from flask import Flask, jsonify

app = Flask(__name__)


@app.route("/")
def hello():
    """Root endpoint returning a JSON greeting."""
    return jsonify(message="Hello CloudEngine Labs - from Python Flask!")


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
