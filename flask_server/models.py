from datetime import datetime
from flask_server import db
from flask_server.leaderboard import *
from werkzeug.security import check_password_hash, generate_password_hash
#from flask_server import login
from flask_login import UserMixin
import numpy as np

class User(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(64), index=True, unique=True)
    firstname = db.Column(db.String(64), index=True, unique=False)
    lastname = db.Column(db.String(64), index=True, unique=False)
    password_hash = db.Column(db.String(128))
    recordings = db.relationship('Recording', backref='author', lazy='dynamic')


    def get_info(self):
        recordings = self.recordings.all()
        scores = []

        for r in recordings:
            scores.append(r.get_score())

        if recordings is None:
            avg = 0
            high = 0
        else:
            avg = np.mean(scores)
            high = np.amax(scores)

        return {"firstname": self.firstname, "lastname": self.lastname,
            "top_score": str(high), "average_score": str(avg)}

    def get_recording(self):
        recordings =  self.recordings.all()
        data = []

        for r in recordings:
            data.append(r.info())

        return data

    def change_username(self, name):
        self.username = name
        db.session.commit()

    def __repr__(self):
        return '<User {}>'.format(self.username)
    
    def set_password(self, password):
        self.password_hash=generate_password_hash(password)

    def check_password(self, password):
        return check_password_hash(self.password_hash, password)

    def get_ID(self):
        return self.id

    def get_username(self):
        return self.username

#the Recording is able to update the leaderboard
#this is following the Observer design pattern
#this is a little forced but I wanted to practice this
class Recording(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    score = db.Column(db.Float)
    timestamp = db.Column(db.DateTime, index=True, default=datetime.utcnow)
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'))
    scale = db.Column(db.String(64), index=False, unique=False)
    key = db.Column(db.String(64), index=False, unique=False)

    def get_score(self):
        return self.score

    def __repr__(self):
        return '<Post {}>'.format(self.score)
    
    def info(self):
        return (str(self.timestamp), str(self.score))

    def get_scale(self):
        return str(scale)

    def get_key(self):
        return str(key)

class Audition(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    is_completed = db.Column(db.Boolean, default=False)
    auditioner = db.Column(db.String(64), index=False, unique=False)
    auditionee = db.Column(db.String(64), index=False, unique=False)
    auditionee_id = db.Column(db.Integer, db.ForeignKey('user.id'))
    score = db.Column(db.Float)
    scale = db.Column(db.String(64), index=True, unique=False)
    key = db.Column(db.String(64), index=True, unique=False)

    def complete(self):
        self.is_completed = True
        db.session.commit()

    def score(self, score):
        self.score = score
        db.session.commit()

    def get_scale(self):
        return self.scale

    def get_complete(self):
        return self.is_completed

    def get_auditioner(self):
        return self.auditioner

    def get_auditionee(self):
        return self.auditionee

    def get_ID(self):
        return self.id
    
    def get_key(self):
        return self.key

    def get_score(self):
        return self.score




