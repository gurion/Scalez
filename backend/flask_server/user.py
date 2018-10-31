#this is a user blueprint to get started

import functools

#this is for setting up a blueprint which can be added to the app factory
from flask import (
        Blueprint, flash, g, redirect, render_template, request, session, url_for
)
from flask_server import db
from flask_json import FlaskJSON, JsonError, json_response, as_json
from flask import jsonify

bp = Blueprint('user', __name__, url_prefix='/user')

@bp.route('/', methods=['POST'])
def new_user():
    #TODO: add in error handeling, the log in must be robust
    data = request.get_json()

    username = data['username']
    password = data['password']
    lastname = data['lastname']
    firstname = data['firstname']

    u = User(username=username, lastname=lastname, firstname=firstname)
    u.set_password(password)
    db.session.add(u)
    db.session.commit()
  
    r = make_summary()
    return jsonify(r)

#TODO: require a log in to access this
#I get the strong feeling this needs to be refactored, but I want to see if I can get
#this to "work" and then go from there
@bp.route('/<username>/recording', methods=['POST'])
def sendScore(username):
    f = request.files['file']

    #get user from database
    #TODO: error handle in case the user is not found
    user = db.session.query(model.User).filter_by(username=username).one()

    #score recording
    score = 42

    #make new recording
    record = Recording(score=42,user_id=user.id)
    db.session.add(record)
    db.session.commit()

    return jsonify(score)


@bp.route('test')
def test():
    return 'this is a test'


