# Build Instructions
1. Be sure to have the postgreSQL database 
2. (a) Go to the .flaskenv and change the DATABASE_URL variable to your database
   (b) Go to the /backend/flask_server and open __init()__, make sure all the database fields match
3. go to the backend folder (The rest should be done in /backend)
4. $ flask db init
5. $ flask db migrate
6. $ flask db upgrade
7. (Make sure that a User model has already been inilized in the database)
  $ python3 add_user.py
8. $ flask run
9. Build XCode project
10. We ran on an XR iOS 12.1 simulator. Others > iOS 12 should work.
11. Press 'Record' and make some noise for a couple seconds. Press 'Stop Recording'
12. Press Upload
13. Press get score and a score for your scale (really just noise, since I'm guessing you don't have an instrument handy (but feel free to sing)) will populate the score field. Scores are error, and lower scores are better


Please call Arpad at 312-401-8223 or Jake at 973-294-8997 if there are any issues building. 
