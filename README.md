# __Scalez__ #
An app to standardize scale practice amd auditions

## __Features__ ##

#### Core Features ####
What we did
* _Create, log in, authenticate_ users
* _Record, upload, and score_ a certain scale/key eg. C maj
* _View personal history_
	* Top score
	* Average score
	* Graph of personal history showing scores over time
* _Auditions_
	* Request a user to complete an audition of a certain scale
	* See all pending auditions for which you are the auditioner or auditionee
	* Complete an audition as requested
	* See the score of completed auditions
* _View a leaderboard_ of top scores and the user and scale associated with them

#### Extended Features ####
What we would do with more time (see `enhancement` issue tag for more details)
* _Create groups of users_
* _Add instrument recognition_
* _Add more types of scales_ (chromatic, pentatonic, etc.)
* _Score a full piece of music_

## __Build Instructions__ ##

#### Current Build ####
1. Clone the project
2. Open the XCode project - `/frontend/Scalez/Scalez/` - in XCode and build for an iOS 12 iPhone Simulator
3. Follow the on-screen instructions

<div style="margin-left: 5rem;">__NOTE:__ This build is connected to our Heroku deployment. If you'd like to implement your own backend, change the host used by the login and create account pages. Likewise, if you'd like to build your own frontend, you can use our API found at `/API/Scalez.postman_collection.json`, and host <a href="https://testdeployment-scalez.herokuapp.com">here</a>
</div>


#### How to build locally ####
1.  Set up a database of SQLite or Postgres
2. With the Database set up, go into command line and set the `DATABASE_URL` enviornment variable to match your newly created database
3. From the root folder run `python db_create.py` this will generate the tables in the database
4. Set the `FLASK_APP` enviornment variable to `server.py`
5. Make sure that all the requirements that are found in requirments.txt are installed
6. Finally enter `flask run` in the command line, this should start the server
