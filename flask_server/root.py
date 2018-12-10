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

#this is a 'global', you can access the global leaderboard through here
bp = Blueprint('root', __name__, url_prefix='/')

@bp.route('test')
def test():
    return 'this is a test'

#@bp.route('\leaderboard', method=['GET'])
#def get_leader_board():
#
#	#return the top 10 high scores

