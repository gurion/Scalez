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
from flask_login import current_user, login_user
from flask_server.models import *
from flask_server.processScales import processScale
from werkzeug.urls import url_parse

# TODO: SET UP USER SESSIONS WITH AUTHNITCATION AND SHIT

bp = Blueprint('user', __name__, url_prefix='/user')


@bp.route('/', methods=['POST'])
def new_user():
    if request.method == 'POST':
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
            return make_error('400', 'user already exsits')
        else:
            u.set_password(password)
            db.session.add(u)
            db.session.commit()
            return response


@bp.route('/login', methods=['GET'])
def login():
    data = request.get_json()

    username = data['username']
    password = data['password']

    check_user = db.session.query(User).filter_by(username=username).first()

    if check_user is None or (check_user.check_password(password) == false):
        return make_error('404', 'Invalid username or password')

    return app.response_class(status=200, mimetype='application/json')

# assumes that the user has a valid login


@bp.route('/<username>/recording', methods=['POST'])
def sendScore(username):
    data = request.get_json()
    audio = data['file']
    # get user from database
    user = db.session.query(User).filter_by(username=username).first()

    # score recording
    score = processScale(audio, 12000)

    # make new recording
    record = Recording(score=score, user_id=user.id)
    db.session.add(record)
    db.session.commit()

    response = app.response_class(
        response=json.dumps(score),
        status=201,
        mimetype='application/json')

    return response

# remove specified user and associated recordings from the database


@bp.route('/<username>', methods=['DEL'])
def del_user(username):

    user = db.session.query(User).filter_by(username=username).first()
    response = app.response_class(status=200, mimetype='application/json')

    if user is None:
        return response

    recordings = user.recordings.all()

    for r in recordings:
        db.session.delete(r)

    db.session.delete(user)
    db.session.commit()

    return response


def make_error(status, message):
    response = jsonify({'status': status, 'message': message})
    return response


@bp.route('test')
def test():
    return 'this is a test'
