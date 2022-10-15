from flask import Flask
app = Flask(__name__)

@app.route('/')
def hello_world():
    return 'CI/CD end to end pipeline using gitops'
