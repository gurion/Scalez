#this is a user blueprint to get started

import functools

#this is for setting up a blueprint which can be added to the app factory
from flask import (
        Blueprint, flash, g, redirect, render_template, request, session, url_for
)
#this is for authentication
from werkzeug.security import check_password_hash, generate_password_hash

bp = Blueprint('user', __name__, url_prefix='/user')



#the focus of this iteration is to send/score recordings
#TODO:  add authentication with passwords
#       check if users are actually in the database
#       General Error Handeling

#@bp.route('/', methods=('POST'))
#def new_user():
#    if request.method == 'POST':

@bp.route('test')
def test():
    return 'this is a test'


