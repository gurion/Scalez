# OOSE Group 21 Changelog

Scale Rating Logic (processScales.py - core algorithm)

  - Added functionality to detect the sequence of half/whole steps in a scale. This will allow us to detect major/minor scale patterns
  - Added an algorithm to score a scale based on a weighted combination of pitch accuracy, dynamic consistency, and note duration 
  - Refactored into a more pipeline-ish design pattern
  - Added proper normalization functionality
  - Added resilience against non scale-like input
  - refactored comments
  - more intuitive folder layout
  
  consistancy
  - Added a temporary way to normalize scale scores
  - Changed from camelCase to unified underscore style
  - Rewrote some functions to better adhere to design principles
  - Added ability to interface with files received from XCode testbed
  - implementing a PIPLINE design pattern for processing audio files
  
XCode (core frontend)
  - Added functionality that allows a user to record audio on a button press
  - Added functionality to convert that audio into raw .wav data
  - Added functionality to send raw audio data to our server
  - Created graphs to track user progress over time
  - Expanded UI
  - Currently wrapping up some audtion functionality
  
flask_server (backend)
- massive update on the backend
- code has been refactored
- there is code to handle errors and badly form JSON
- Added the audition Model and successfully implemented most of the audition routes
- Implemented leaderboard functionality
- added more unit tests for simple CRUD and for the observer design pattern
- Added an Observer design pattern for leaderboards
  
Heroku Deployment (backend)
 - heroku backend deployment and Postgres is working fine

PostMan Tests
- These need to be taken with a grain of salt
- Postman hasn't been ideal for testing our app because it cant take file uploads
- We have some basic cases and the backend has been ironed out but there are still couple fixes that need to be made

Backend bugs
- The complete audition endpoint still needs a little bit of fine tuning
- The get (ALL) auditions endpoint needs to be finished
- Profile info route was changed so its different from the API
- Tighten up response output bodies to make the front end people's lives a little easier
