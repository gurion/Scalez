import functools
import json

# this is for setting up a blueprint which can be added to the app factory
from flask import (
    Blueprint, flash, g, redirect, render_template, request, session, url_for
)
from flask_server import db
from flask import jsonify
from flask_server import app
#from flask_login import current_user, login_user
from flask_server.models import *
from flask_server import global_leaderboard

#this is a 'global', you can access the global leaderboard through here
bp = Blueprint('root', __name__, url_prefix='/')

@bp.route('test')
def test():
    return 'this is a test'

@bp.route('/leaderboard', methods=['GET'])
def get_leaderboard():
	if request.method == 'GET':

		scores = global_leaderboard.get_scores()
		history = []

		for index in range(0,len(scores)):
			entry = {'username' : scores[index][0], 'scale': scores[index][1], 
					'key': scores[index][2], 'score': scores[index][3] }
			history.append(entry)

		return jsonify({'leaderboard': history}), 200

