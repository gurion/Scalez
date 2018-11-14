from flask_server import db
from flask_server.models import *
u = User(username='Gurion', lastname='last', firstname='first', password_hash='password')
db.session.add(u)
db.session.commit()
