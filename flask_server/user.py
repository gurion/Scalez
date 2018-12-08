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

bp = Blueprint('user', __name__, url_prefix='/user')

@bp.route('/', methods=['POST'])
def new_user():

    if request.method == 'POST':
        data = request.get_json()

        username = data['username']
        password = data['password']
        lastname = data['lastname']
        firstname = data['firstname']

        u = User(username=username, lastname=lastname, firstname=firstname)

        # check for same username,
        check = db.session.query(User).filter_by(username=username).first()
        if check:
            return make_error('400', 'user already exsits')
        else:
            u.set_password(password)
            db.session.add(u)
            db.session.commit()
            return jsonify({'status'=201, 'message'="new user made"})

@bp.route('/login', methods=['POST'])
def login():
    data = request.get_json()
   
    username = data['username']
    password = data['password']

    check_user = db.session.query(User).filter_by(username=username).first()

    if check_user is None or (check_user.check_password(password) == false):
        return make_error('404', 'bad login, username or passwrod incorrect')

    return jsonify({'status'=201, 'message'='user has been logged in'})

#assumes that the user has a valid login
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

    return jsonify({'score'=score, 'status'=201, 'message'='new recording has been created'})

#remove specified user and associated recordings from the database
@bp.route('/<username>', methods=['DEL'])
def del_user(username): 
    
    user = db.session.query(User).filter_by(username=username).first() 
    
    if user is None:
        return response

    recordings = user.recordings.all()
    auditions = user.auditions.all()

    #delete recordings here
    for r in recordings:
        db.session.delete(r)

    #delet auditions here
    for a in aditions:
        db.session.delete(a)

    db.session.delete(user)
    db.session.commit()

    return jsonify({'status':200, 'message':"user has been removed"})

@bp.route('/<username>', methods=['PUT'])
def change_name(username)
    data = request.get_json() #get the new username form the request
    
    #search of user in database
    user = db.session.query(User).filter_by(username=username).first() 
    
    if user is None
        return make_error(404,'user not found')

    user.change_username(user.data['username'])
    return jsonify({'status'=204, 'message'='username has been changed'})

#this is just to make it explicit when I'm making an error
def make_error(status, message):
    return = jsonify({'status': status, 'message':message})

@bp.route('test')
def test():
    return 'this is a test'

