# Scalez
An app to standardize scale practice

## Build Instructions
<details><summary>Current Build</summary>
	<ol>
		<li> Clone the project
		<li> Open the XCode project - `/frontend/Scalez/Scalez/` - in XCode and build for an iOS 12 iPhone Simulator
		<li> Follow the on-screen instructions
	</ol>
	 __NOTE:__ This build is connected to our Heroku deployment. If you'd like to implement your own backend, change the host used by the login and create account pages. Likewise, if you'd like to build your own frontend, you can use our API found at `/API/Scalez.postman_collection.json`, and host <a href="https://testdeployment-scalez.herokuapp.com">here</a>
<p>
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
<p>
## Root Directory Files
While there a quite a few python files in the root directory, this is so heroku can build and use them. We want to get this cleaned up, this will be fixed come iteration 6
