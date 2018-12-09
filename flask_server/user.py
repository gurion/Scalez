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
#from flask_login import current_user, login_user
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
            return jsonify({'message':'new user made'}), 201

@bp.route('/login', methods=['POST'])
def login():

    if request.method == 'POST':
        data = request.get_json()
       
        username = data['username']
        password = data['password']

        check_user = db.session.query(User).filter_by(username=username).first()

        if check_user is None or (check_user.check_password(password) == false):
            return make_error('404', 'bad login, username or passwrod incorrect')

        return jsonify({'message':'user has been logged in'}), 201

#Scores the recording
@bp.route('/<username>/recording', methods=['POST'])
def sendScore(username):

    if request.method == 'POST':
        data = request.get_json()
        
        try:
            audio = data['file']
        except KeyError:
            return make_error(400,'Bad Request')

        # get user from database
        user = db.session.query(User).filter_by(username=username).first()

        # score recording
        score = processScale(audio, 12000)

        # make new recording
        record = Recording(score=score, user_id=user.id)
        db.session.add(record)
        db.session.commit()

        return jsonify({'score':score, 'message':'new recording has been created'}), 201

#remove specified user and associated recordings from the database
@bp.route('/<username>', methods=['DEL'])
def del_user(username): 

    if request.method == 'DEL':
    
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

        return jsonify({'message':'user has been removed'}), 200

#changes the username to the one in the request body
@bp.route('/<username>', methods=['PUT'])
def change_name(username):

    if request.method == 'PUT':
        data = request.get_json() #get the new username form the request
        
        #search of user in database
        user = db.session.query(User).filter_by(username=username).first()  
        if user is None:
            return make_error(404,'user not found')
        
        try:
            user.change_username(user.data['username'])
        except KeyError:
            return make_error(400,'Bad Request')

        return jsonify({'message':'username has been changed'}), 204

#this is just to make it explicit when I'm making an error
def make_error(status, message):
    return jsonify({'error': message}), status

#get the current user's leaderboard
@bp.route('/<username>/leaderboard', methods=['GET'])
def get_leaderboard(username):

    if request.method == 'GET':
        user = db.session.query(User).filter_by(username=username).first()
        if user is None:
            return make_error(404,'user not found')

        #TODO : fix the user.get_recording to have the right format
        return jsonify({user.get_recording()}), 200

#new audition
@bp.route('/<username>/audition', methods=['POST'])
def new_audition(username):

    if request.method == 'POST':
        data = request.get_json()
        
        try:
            auditionee = data['auditionee']
            scale = data['scale']
        except KeyError:
            return make_error(400, 'bad json')

        auditionee = db.session.query(User).filter_by(username=auditionee).first()
        auditioner = db.session.query(User).filter_by(username=username).first()

        if auditionee or auditioner is None:
            return make_error(404, 'auditionee or auditioner not found')

        #create the audition object
        aud = Audtion(  is_completed = False,
                        auditioner = username,
                        auditionee = audtionee,
                        auditionee_id = auditioner.get_ID(),
                        score = 0,
                        scale = scale
                     )
        
        db.session.add(aud)
        db.session.commit()

        return jsonify({'message':'audition created'}), 200

#this is to get and complete auditions
@bp.route('/<username>/audition/<audtionID>', methods=['GET', 'PUT'])
def audition_update(auditionID):

    data = request.get_json()
    aud = Audition.query.get(int(auditionID))
    
    if aud is None:
        return make_error(400, 'Bad auditionID')

    if request.method == 'GET':
        return jsonify({'message':'found audition'}), 200

    if request.method == 'PUT':
        
        try:
            audio = data['file']
            rate = data['rate']
            frame_count = data['frameCount']
        except KeyError:
            return make_error(400, 'no file in request body')
        
        score = processScales(audio, 12000)
        aud.complete()
        aud.score(score)

@bp.route('test')
def test():
    return 'this is a test'

