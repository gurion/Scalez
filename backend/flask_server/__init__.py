import os

from flask import Flask
from config import Config
from flask_sqlalchemy import SQLAlchemy
from flask_migrate import Migrate

app = Flask(__name__)
app.config.from_object(Config)
db = SQLAlchemy(app)
migrate = Migrate(app, db)

POSTGRES = {
    'user': 'postgres',
    'pw': 'Arpiarpi2',
    'db': 'testdb',
    'host': 'localhost',
    'port': '5432',
}
app.config['SQLALCHEMY_DATABASE_URI'] = 'postgresql://%(user)s:\
%(pw)s@%(host)s:%(port)s/%(db)s' % POSTGRES


#following the grinberg tutorial, I'm importing the models and blueprints
#on the last line
from flask_server import models, user
app.register_blueprint(user.bp)
