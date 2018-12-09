from datetime import datetime
from flask_server import db
from werkzeug.security import check_password_hash, generate_password_hash
#from flask_server import login
from flask_login import UserMixin


'''
@login.user_loader
def load_user(id):
    return User.query.get(int(id))
'''

class User(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(64), index=True, unique=True)
    firstname = db.Column(db.String(64), index=True, unique=False)
    lastname = db.Column(db.String(64), index=True, unique=False)
    password_hash = db.Column(db.String(128))
    recordings = db.relationship('Recording', backref='author', lazy='dynamic')
   # auditionee = db.relationship('Audition', backref='auditionee', lazy='dynamic')
   # auditioner = db.relationship('Audition', backref='auditioner', lazy='dyanmic')

    def get_recording(self):
        recordings =  self.recordings.all()
        data = []

        for r in recordings:
            data.append(r.response_string())

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

class Recording(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    score = db.Column(db.Float)
    timestamp = db.Column(db.DateTime, index=True, default=datetime.utcnow)
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'))
    
    def __repr__(self):
        return '<Post {}>'.format(self.score)
    
    def response_string(self):
        return (str(self.timestamp) + ' : ' + str(self.score))

'''
class Audition(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    auditioner = db.Column(db.Integer, db.ForeignKey('user.id'))
    auditionee = db.Column(db.Integer, db.ForeignKey('user.id'))
    is_completed = db.Column(db.Boolean, default=False)
    score = db.Column(db.Float)
'''
