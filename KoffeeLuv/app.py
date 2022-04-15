from flask import Flask
import socket

hostname = socket.gethostname()
ipaddress = socket.gethostbyname(hostname)

app = Flask(__name__)


@app.route("/")
def hello():
    return f"The Future Home of Koffee Luv. {ipaddress}  and hostname is {hostname}."


if __name__ == '__main__':
    app.run(host="0.0.0.0", port=5000)
