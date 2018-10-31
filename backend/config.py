import os

basedir = os.path.abspath(os.path.dirname(__file__))

class Config(object):
   # This is the SQLite set up! DO NOT USE THIS FOR HEROKU
   # SQLALCHEMY_DATABASE_URI = os.environ.get('DATABASE_URL') or \
   #         'sqlite:///' + os.path.join(basedir, 'app.db')
   # SQLALCHEMY_TACK_MODIFICATIONS = False

   SQLALCHEMY_DATABASE_URI = os.environ.get('DATABASE_URL')
