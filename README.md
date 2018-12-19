# Scalez #
An app to standardize scale practice

## Features ##

<details><summary><b>Core Features</b></summary>
What we did
	<ul>
	<li> <i>Create and log in</i> users</li>
	<li> <i>Record and upload</i> a certain scale/key eg. C maj</li>
 	<li> <i>View personal history</i>
	<ul>
	<li> Top score
	<li> Average score
	<li> Graph of personal history showing scores over time
	</ul>
	<li> <i>Auditions</i>
	<ul>
	<li> Request a user to complete an audition of a certain scale
	<li> See all pending auditions for which you are the auditioner or auditionee
	<li> Complete an audition as requested
	<li> See the score of completed auditions
	</ul>
	<li> <i>View a leaderboard</i> of top scores and the user and scale associated with them
	</ul>
</details>
<br>
<details><summary><b>Extended Features</b></summary>
What we would do with more time (see `enhancement` issue tag for more details)
	<ul>
	<li> <i>Create groups of users</i>
	<li> <i>Add instrument recognition</i>
	<li> <i>Add more types of scales</i> (chromatic, pentatonic, etc.)
	<li> <i>Score a full piece of music</i>
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
<br>
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
