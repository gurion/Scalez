## OOSE Group 21 Changelog

**Scale Rating Logic** *(processScales.py - core algorithm)*
  - Added functionality to detect the sequence of half/whole steps in a scale. This will allow us to detect major/minor scale      patterns
  - Added an algorithm to score a scale based on a weighted combination of pitch accuracy, dynamic consistency, and note duration consistancy
  - Added a temporary way to normalize scale scores
  - Changed from camelCase to unified underscore style
  - Rewrote some functions to better adhere to design principles
  - Added ability to interface with files received from XCode testbed

**XCode** *(core frontend)*
  - Added functionality that allows a user to record audio on a button press
  - Added functionality to convert that audio into raw .wav data
  - Added functionality to send raw audio data to our server

**flask_server** *(backend)*
  - Added user blueprint
  - Debug user/test route
  - Integrated Scale Rating logic
  - Created postrgreSQL database
  - Created User and Recording models
  - Users have password_hash
  - Recording require a User from the database to be instantiated
  - added .flaskenv file
  - Updated requirments.txt
  - Recordings have a time 
