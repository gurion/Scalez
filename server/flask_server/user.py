import functools
import json

# this is for setting up a blueprint which can be added to the app factory
from flask import (
    Blueprint, flash, g, redirect, render_template, request, session, url_for
)
from flask_server import db
from flask_server import obsv
from flask_server import global_leaderboard
from flask_json import FlaskJSON, JsonError, json_response, as_json
from flask import jsonify
from flask_server import app
# from flask_login import current_user, login_user
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
            return jsonify({'message': 'new user made'}), 201


@bp.route('/login', methods=['POST'])
def login():

    if request.method == 'POST':
        data = request.get_json()

        username = data['username']
        password = data['password']

        check_user = db.session.query(User).filter_by(username=username).first()

        if check_user is None or (check_user.check_password(password) == False):
            return make_error('404', 'bad login, username or passwrod incorrect')

        return jsonify({'message': 'user has been logged in'}), 201

# Scores the recording


@bp.route('/<username>/recording', methods=['POST'])
def sendScore(username):

    if request.method == 'POST':
        data = request.get_json()

        try:
            audio = data['file']
            scale = data['scale']
            key = data['key']
        except KeyError:
            return make_error(400, 'Bad Request')

        # get user from database
        user = db.session.query(User).filter_by(username=username).first()

        if user is None:
            return make_error(404, 'user not found')

        # score recording
        score = float(processScale(audio,12000))

        record = Recording(score=score, user_id=user.get_ID(), scale=scale,
            key=key)
        db.session.add(record)
        db.session.commit()

        obsv.notify_leaderboards(user.get_username(),scale, key, score)

        return jsonify({'score': score, 'message': 'new recording has been created'}), 201

# remove specified user and associated recordings from the database


@bp.route('/<username>', methods=['DEL'])
def del_user(username):

    if request.method == 'DEL':

        user = db.session.query(User).filter_by(username=username).first()

        if user is None:
            return response

        recordings = user.recordings.all()

        # delete recordings here
        for r in recordings:
            db.session.delete(r)

        db.session.delete(user)
        db.session.commit()

        return jsonify({'message': 'user has been removed'}), 200

# changes the username to the one in the request body


@bp.route('/<username>', methods=['PUT'])
def change_name(username):

    if request.method == 'PUT':
        data = request.get_json()  # get the new username form the request

        # search of user in database
        user = db.session.query(User).filter_by(username=username).first()
        if user is None:
            return make_kierror(404,'user not found')
        try:
            user.change_username(user.data['username'])
        except KeyError:
            return make_error(400, 'Bad Request')

        return jsonify({'message': 'username has been changed'}), 204

# this is just to make it explicit when I'm making an error


def make_error(status, message):
    return jsonify({'error': message}), status

# get the current user's leaderboard


@bp.route('/<username>/leaderboard', methods=['GET'])
def get_leaderboard(username):

    if request.method == 'GET':
        user = db.session.query(User).filter_by(username=username).first()
        if user is None:
            return make_error(404, 'user not found')


# new audition

        #TODO : fix the user.get_recording to have the right format
        recordings = user.get_recording()
        history = []

        for index in range(len(recordings)):
            entry = {'timestamp' : recordings[index][0],
                'score': recordings[index][1] }

            history.append(entry)

        return jsonify({'history': history}), 200

#new audition
@bp.route('/<username>/audition', methods=['POST', 'GET'])

def new_audition(username):

    if request.method == 'POST':
        data = request.get_json()

        try:
            auditionee = data['auditionee']
            scale = data['scale']
            key = data['key']
        except KeyError:
            return make_error(400, 'bad json')

        auditionee = db.session.query(User).filter_by(username=auditionee).first()
        auditioner = db.session.query(User).filter_by(username=username).first()

        if auditioner is None:
            return make_error(404, 'auditioner not found')

        if auditionee is None:
            return make_error(404, 'auditionee not found')
        #create the audition object
        aud = Audition(  is_completed = False,
                        auditioner = username,
                        auditionee = auditionee.get_username(),
                        score = 0,
                        scale = scale,
                        key = key
                     )

        db.session.add(aud)
        db.session.commit()

        return jsonify({'message': 'audition created'}), 201

# get all the auditions for which the user is the auditionee
# TODO: make sure to fix the response body of this becuase it needs to be finished



    if request.method == 'GET':
        user = db.session.query(User).filter_by(username=username).first()
        audee = get_all_auditionee(username)
        auder = get_all_auditioner(username)

        #get auditions where the user is the auditionee
        auditioneelist = []
        auditionerlist = []

        for a in audee:
            entry = audition_JSON(a)

            auditioneelist.append(entry)

        #get auditions where the user is the auditioner
        for a in auder:
            entry = audition_JSON(a)

            auditionerlist.append(entry)

        return jsonify({"auditions" : {'auditionee': auditioneelist,
            'auditioner': auditionerlist}}), 200

# this is to get and complete auditions
@bp.route('/<username>/audition/<auditionID>', methods=['GET', 'PUT'])
def audition_update(username, auditionID):

    data = request.get_json()
    aud = Audition.query.get(int(auditionID))

    if aud is None:
        return make_error(400, 'Bad auditionID')

    if request.method == 'GET':

        return jsonify(audition_JSON(aud)), 200


    if request.method == 'PUT':

        try:
            audio = data['file']
        except KeyError:
            return make_error(400, 'no file in request body')

        score = float(processScale(audio,12000))

        aud.complete()
        aud.set_score(score)

        db.session.commit()

        return jsonify(audition_JSON(aud)), 200


@bp.route('test')
def test():
    return 'this is a test'


@bp.route('/<username>/info', methods=['GET'])
def get_info(username):
    if request.method == 'GET':
        user = db.session.query(User).filter_by(username=username).first()

        if user is None:
            return make_error(404, 'user was not found')

        return jsonify({'info': user.get_info()}), 200

'''
want to keep all JSON processing inthe routes
'''

#get all auditions where the username is the auditioner
#just an easy helper method that may be more conveniant to use
def get_all_auditioner(username):
    auditions = db.session.query(Audition).filter_by(auditioner=username).all()
    return auditions

def get_all_auditionee(username):
    auditions = db.session.query(Audition).filter_by(auditionee=username).all()
    return auditions

#get the JSON of the audition
def audition_JSON(aud):
    return {'id': aud.get_ID(), 'auditionee': aud.get_auditionee(),
                'scale': aud.get_scale(), 'key': aud.get_key(),
                'auditioner': aud.get_auditioner(),
                'isComplete': aud.get_complete(), 'score': aud.get_score() }
