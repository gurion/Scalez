import psycopg2
import os

from flask_login import LoginManager
from flask import Flask, session
from flask_sqlalchemy import SQLAlchemy
from flask_migrate import Migrate
from flask_server.leaderboard import *


app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = os.environ["DATABASE_URL"]
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
db = SQLAlchemy(app)
global_leaderboard = LeaderBoard(length=10) #top 10 scores
obsv = UpdateLeaderboard() #makeing use of an observer design pattern
obsv.add_leaderboard(global_leaderboard) #global leaderboard added to the observer
login = LoginManager(app)
migrate = Migrate(app, db)

#following the grinberg tutorial, I'm importing the models and blueprints
#on the last line
from flask_server import root
from flask_server import user
from flask_server.models import * 
app.register_blueprint(user.bp)
app.register_blueprint(root.bp)
