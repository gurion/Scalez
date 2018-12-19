# Scalez

## Build Instructions
<details><summary>Current Build</summary>
	<ol>
		<li> Clone the project
		<li> Open the XCode project - `/frontend/Scalez/Scalez/` - in XCode and build for an iOS 12 iPhone Simulator
		<li> Follow the on-screen instructions
	</ol>

<details><summary>How to build locally</summary>
	<ol>
		<li> Set up a database of SQLite or Postgres
		<li> With the Database set up, go into command line and set the `DATABASE_URL`
		enviornment variable to match your newly created database
		<li> From the root folder run `python db_create.py` this will generate the tables in the database
		<li> Set the `FLASK_APP` enviornment variable to `server.py`
		<li> Make sure that all the requirments that are found in requirments.txt are
		installed
		<li> Finally enter `flask run` in the command line, this should start the server
	</ol>

## Root Directory Files
While there a quite a few python files inthe root directory, this is so heroku can build
and use them.

We wanted to get this cleaned up, this will be fixed come iteration 6



NOTE: AS OF NOW THE FRONT END IS CONNECTED TO THE HEROKU BUILD. YOU WOULD
	HAVE TO GO IN MANUALLY AND CHANGE THE HOST IN SWIFT IF YOU SET UP
	YOUR OWN BACKEDN


#to try on deployed app
