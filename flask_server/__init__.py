import psycopg2
import os

from flask_login import LoginManager
from flask import Flask
#from config import Config
from flask_sqlalchemy import SQLAlchemy
from flask_migrate import Migrate


app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = os.environ["DATABASE_URL"]
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
DATABASE_URL = os.environ['DATABASE_URL']
#conn = psycopg2.connect(DATABASE_URL, sslmode='require')
db = SQLAlchemy(app)
login = LoginManager(app)
migrate = Migrate(app, db)

#following the grinberg tutorial, I'm importing the models and blueprints
#on the last line
from flask_server import models, user
app.register_blueprint(user.bp)
