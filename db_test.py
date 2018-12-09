from flask_server import db
from flask_server.models import *
import unittest

'''
PLEASE READ THIS BEFORE RUNNING!

MAKE SURE THAT AN INSTANCE OF THE DATABASE HAS BEEN SET UP FIRST
THIS CAN BE DONE FOR YOU BY RUNNING db_create.py first
IT IS ALSO RECCOMNEDED BUT NOT NECCESSARY TO HAVE RUN db_clear.py TO CLEAR OUT
THE DATABASE BEFORE RUNNING db_test.py
'''

#these are test methods to garuntee that the CRUD is working as intended

class UserTestCase(unittest.TestCase):
    def setUp(self):
        u = User(username='test', lastname='last1', firstname='first1')
        db.session.add(u)
        db.session.commit()

        #add some recordings too!
        r1 = Recording(score=42, user_id=u.id)
        r2 = Recording(score=24, user_id=u.id)
        db.session.add(r1)
        db.session.add(r2)
        db.session.commit()

    def test_exist(self):
        user = db.session.query(User).filter_by(username='test').first()
        self.assertIsNotNone(user)
    
    def test_namechange(self):
        user = db.session.query(User).filter_by(username='test').first()
        self.assertIsNotNone(user)
        user.change_username('change')
        user = db.session.query(User).filter_by(username='change').first()
        self.assertIsNotNone(user)
        user.change_username('test')
        user = db.session.query(User).filter_by(username='test').first()
        self.assertIsNotNone(user)

    def test_recordings(self):
        user = db.session.query(User).filter_by(username='test').first() 
        print(user.get_recording())
        self.assertTrue(True) 


    def tearDown(self):
        user = db.session.query(User).filter_by(username='test').first()
        recordings = user.recordings.all()

        for r in recordings:
            db.session.delete(r)

        db.session.delete(user)
        db.session.commit()


if __name__ == '__main__':
    unittest.main()
