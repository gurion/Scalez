# this is a user blueprint to get started

import functools
import json

# this is for setting up a blueprint which can be added to the app factory
from flask import (
    Blueprint, flash, g, redirect, render_template, request, session, url_for
)
from flask_server import db
from flask_json import FlaskJSON, JsonError, json_response, as_json
from flask import jsonify
from flask_server import app
from flask_server.models import *

from flask_server.processScales import processScale

bp = Blueprint('user', __name__, url_prefix='/user')


@bp.route('/', methods=['POST', 'GET'])
def new_user():
    # TODO: add in error handeling, the log in must be robust

    if request.method == 'GET':
        response = app.response_class(status=200, mimetype='application/json')
        return response

    elif request.method == 'POST':
        data = request.get_json()

        username = data['username']
        password = data['password']
        lastname = data['lastname']
        firstname = data['firstname']

        response = app.response_class(status=201, mimetype='application/json')
        u = User(username=username, lastname=lastname, firstname=firstname)

        # check for same username,
        check = db.session.query(User).filter_by(username=username).first()
        if check:
            return response
        else:
            u.set_password(password)
            db.session.add(u)
            db.session.commit()
            return response

# TODO: require a log in to access this
# I get the strong feeling this needs to be refactored, but I want to see if I can get
# this to "work" and then go from there


@bp.route('/<username>/recording', methods=['POST'])
def sendScore(username):
    data = request.get_json()
    audio = data['file']
    # get user from database
    # TODO: error handle in case the user is not found
    user = db.session.query(User).filter_by(username=username).one()

    # score recording
    score = processScale(audio, 12000)

    # make new recording
    record = Recording(score=score, user_id=user.id)
    db.session.add(record)
    db.session.commit()

    return json.dumps(score)


@bp.route('test')
def test():
    return 'this is a test'
