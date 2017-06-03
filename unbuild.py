#!/usr/bin/env python3
from os import path
import subprocess

import flask
from flask import Flask, Response
from flask import request
from flask_cors import cross_origin

app = Flask(__name__)

ROOT_PATH = path.dirname(path.abspath(__file__))

EMAILS = {
    'ethanjli': 'lietk12@gmail.com',
    'gersh': 'gershon.bialer@gmail.com'
}

SCRIPT_PATH = path.join(ROOT_PATH, 'commit_project.sh')
COMMIT_MESSAGE_FILE = 'commit_message.txt'
HTML_FILE = 'stella.html'

# HANDLERS

def commit_project(user_name, commit_message, html):
    print('Handling commit request from {}:\n{}'.format(user_name, commit_message))
    if not commit_message:
        raise ValueError('Empty commit message!')
    if not html:
        raise ValueError('Empty Twine HTML file!')
    try:
        with open(path.join(ROOT_PATH, COMMIT_MESSAGE_FILE), 'w') as f:
            f.write(commit_message)
        with open(path.join(ROOT_PATH, HTML_FILE), 'w') as f:
            f.write(html)
        user_email = EMAILS[user_name]
        subprocess.check_call(['/bin/bash', SCRIPT_PATH, user_name, user_email],
                              stderr=subprocess.STDOUT)
    except KeyError:
        raise ValueError('Unknown user!')
    except subprocess.CalledProcessError:
        raise RuntimeError('Unbuild/commit failed!')

# ROUTES

@app.route('/')
def ping():
    return "Hello, World!"

@app.route('/save', methods=['POST'])
@cross_origin()
def save():
    data = request.get_json(force=True)
    try:
        commit_project(data['auth']['username'], data['message'], data['html'])
        response = flask.make_response('{"status": "success"}')
        response.headers['Content-Type'] = 'application/json'
    except ValueError as e:
        raise
        #response = flask.make_response('{"status": "error", "error": "' + str(e) + '"}')
        #response.status_code = 400
    except RuntimeError as e:
        raise
        #response = flask.make_response('{"status": "error", "error": "' + str(e) + '"}')
        #response.status_code = 500
    return response

if __name__ == '__main__':
    app.run()

