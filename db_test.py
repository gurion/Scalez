from flask_server import db
from flask_server.leaderboard import *
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
        print(str(user.get_ID()) + ' this is  a user id \n')
    
    def test_namechange(self):
        user = db.session.query(User).filter_by(username='test').first()
        self.assertIsNotNone(user)
        user.change_username('change')
        user = db.session.query(User).filter_by(username='change').first()
        self.assertIsNotNone(user)
        user.change_username('test')
        user = db.session.query(User).filter_by(username='test').first()
        self.assertIsNotNone(user)

    #check the formatting manually
    #this is just for sanity checking
    def test_recordings(self):
        user = db.session.query(User).filter_by(username='test').first() 
        print(user.get_recording())
        self.assertTrue(True) 

    #I want to check the output manually
    # av should be 33 and hight should be 42
    def test_scores(self):
        user = db.session.query(User).filter_by(username='test').first()
        print(user.get_info())
        self.assertTrue(True)

    def tearDown(self):
        user = db.session.query(User).filter_by(username='test').first()
        recordings = user.recordings.all()

        for r in recordings:
            db.session.delete(r)

        db.session.delete(user)
        db.session.commit()

'''
These objects just have simple muators and getters
There is no need to give them sperate test cases yet
or maybe ever
'''

class LeaderBoardTestCase(unittest.TestCase):
   # def setUp(self):
   #     #makes some users
   #
   #     u1 = User(username='test1', lastname='last1', firstname='first1')
   #     db.session.add(u1)
   #     db.session.commit()

    def test_notify(self):
        u1 = User(username='test10', lastname='last1', firstname='first1')
        db.session.add(u1)
        db.session.commit()

        recordings = []
        #create an instance of the board of length 6
        board = LeaderBoard(3)
        ##generate some recordings

        '''
        for i in range(0,3):
            r = Recording(score=i, user_id=u1.id)
            r.add_leaderboard(board)
            r.notify_leaderboard()
            db.session.add(r)
            recordings.append(r)
            db.session.commit()
        '''

        obsv = UpdateLeaderboard()
        obsv.add_leaderboard(board)


        r1 = Recording(score=1, user_id=u1.id)
        r2 = Recording(score=2, user_id=u1.id)
        r3 = Recording(score=3, user_id=u1.id)
        r4 = Recording(score=4, user_id=u1.id)
        r5 = Recording(score=5, user_id=u1.id)

        obsv.notify_leaderboards(u1.get_username(), 1)
        obsv.notify_leaderboards(u1.get_username(), 2)
        obsv.notify_leaderboards(u1.get_username(), 3)
        obsv.notify_leaderboards(u1.get_username(), 4)
        obsv.notify_leaderboards(u1.get_username(), 5)

        #print out the result
        print(board.response_string())
        self.assertTrue(True)

    def tearDown(self):
        users = User.query.all()
        recordings = Recording.query.all()

        for u in users:
            db.session.delete(u)

        for r in recordings:
            db.session.delete(r)

        db.session.commit()



# class AuditionTestCase(unittest.TestCase):


if __name__ == '__main__':
    unittest.main()
