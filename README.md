# Build Instructions 
1. Download the project from Github
2. Open the XCode project in XCode and build for an iOS 12 iPhone Simulator
3. Follow the on-screen instructions

## Deprecated Build Instructions

<details><summary>How to build locally</summary>
<p>

#to run locally

1. Set up a database of SQLite or Postgres
2. With the Database set up, go into command line and set the DATABASE_URL
	enviornment variable to match your newly created database
3. from the root folder run "python db_create.py", this will generate the tables
	in the database
4. Set the FLASK_APP enviornment variable to "server.py"
5. Make sure that all the requirments that are found in requirments.txt are
	installed
6. Finally enter "flask run" in the command line, this should start the
	server

NOTE: AS OF NOW THE FRONT END IS CONNECTED TO THE HEROKU BUILD. YOU WOULD
	HAVE TO GO IN MANUALLY AND CHANGE THE HOST IN SWIFT IF YOU SET UP
	YOUR OWN BACKEDN


#to try on deployed app
