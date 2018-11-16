from flask_server import db
from flask_server.models import *
users = User.query.all()
recordings = Recording.query.all()

for u in users:
    db.session.delete(u)

for r in recordings:
    db.session.delete(r)

db.session.commit()

