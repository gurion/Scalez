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

@bp.route('test')
def test():
    return 'this is a test'


