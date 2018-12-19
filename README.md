# Scalez #
An app to standardize scale practice

## Features ##

<details><summary><b>Core Features</b></summary>
<b>What we did<b>
	<ul>
	<li> _Create and log in_ users</li>
	<li> _Record and upload_ a certain scale/key eg. C maj</li>
 	<li> _View personal history_
	<ul>
	<li> Top score
	<li> Average score
	<li> Graph of personal history showing scores over time
	</ul>
	<li> _Auditions_
	<ul>
	<li> Request a user to complete an audition of a certain scale
	<li> See all pending auditions for which you are the auditioner or auditionee
	<li> Complete an audition as requested
	<li> See the score of completed auditions
	</ul>
	<li> _View a leaderboard_ of top scores and the user and scale associated with them
	</ul>
</details>

<details><summary><b>Extended Features</b></summary>
What we would do with more time (see `enhancement` issue tag for more details)
	<ul>
	<li> _Create groups of users_
	<li> _add instrument recognition_
	<li> _add more types of scales_ (chromatic, pentatonic, etc.)
	<li> _score a full piece of music_
	</ul>
</details>



## Build Instructions ##
<details><summary>Current Build</summary>
	<ol>
		<li> Clone the project
		<li> Open the XCode project - `/frontend/Scalez/Scalez/` - in XCode and build for an iOS 12 iPhone Simulator
		<li> Follow the on-screen instructions
	</ol>
	<div style="margin-left: 5rem;">__NOTE:__ This build is connected to our Heroku deployment. If you'd like to implement your own backend, change the host used by the login and create account pages. Likewise, if you'd like to build your own frontend, you can use our API found at `/API/Scalez.postman_collection.json`, and host <a href="https://testdeployment-scalez.herokuapp.com">here</a>
	</div>
</details>
<details><summary>How to build locally</summary>
	<ol>
		<li> Set up a database of SQLite or Postgres
		<li> With the Database set up, go into command line and set the `DATABASE_URL`
		enviornment variable to match your newly created database
		<li> From the root folder run `python db_create.py` this will generate the tables in the database
		<li> Set the `FLASK_APP` enviornment variable to `server.py`
		<li> Make sure that all the requirements that are found in requirments.txt are
		installed
		<li> Finally enter `flask run` in the command line, this should start the server
	</ol>
</details>
