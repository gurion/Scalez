# Build Instructions
Be sure to have the postgreSQL database
1.  (a) Go to the .flaskenv and change the DATABASE_URL variable to your database 

    (b) Go to the /backend/flask_server and open init(), make sure all the POSTGRES fields match (look at lines 14-18 in init)
2. go to the backend folder (The rest should be done in /backend)
3. $ flask db init
4. $ flask db migrate
5. $ flask db upgrade
6. $ python3 add_user.py 
   (Make sure that a User model has already been inilized in the database)
7. $ flask run
8. Build XCode project
   We ran on an XR iOS 12.1 simulator. Others > iOS 12 should work.
9. Press 'Record' and make some noise for a couple seconds. Press 'Stop Recording'
10. Press Upload
11. Press get score and a score for your scale (really just noise, since I'm guessing you don't have an instrument handy (but feel free to sing)) will populate the score field. Scores are error, and lower scores are better
12. Please call Arpad at 312-401-8223 or Jake at 973-294-8997 if there are any issues building.
