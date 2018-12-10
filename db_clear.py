from flask_server import db
from flask_server.models import *
users = User.query.all()
recordings = Recording.query.all()
auditions = Audition.query.all()

for u in users:
    db.session.delete(u)

for r in recordings:
    db.session.delete(r)

for a in auditions:
    db.session.delete(a)

db.session.commit()

