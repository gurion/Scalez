import numpy as np
from operator import itemgetter


class LeaderBoard:

	def __init__(self, length):
		self.length = length
		self.highest = 0
		self.lowest = 0
		self.board = []

	def notify(self, name, score):
		#update the leaderboard
		if score >= self.lowest:
			self.board.append((name,score))

		self.board = sorted(self.board, key=itemgetter(1), reverse=True)
		print(self.board)
		if len(self.board) > self.length:
			self.board = self.board[:(self.length)]

		self.highest = self.board[0][1]
		self.lowest = self.board[(len(self.board))-1][1]


	def response_string(self):
		#print out the leader board as you would in a response
		response = "leaderboard : { "

		for i in range(0,len(self.board)):

			if (i == (len(self.board)-1)):
				response = (response + str(self.board[i][0]) + " : " +
					str(self.board[i][1]) + " }") 

			else:
				response = (response + str(self.board[i][0]) + " : " +
					str(self.board[i][1]) + ", ")  

		return response

#this is a little forced but I wanted to try to implement an Observer pattern
#this may come in handy if we create more leaderboards but it might be a bit overkill
#but writing server routes got a little tiresome
class UpdateLeaderboard:

	def __init__(self):
		self.leaderboards = []

	def add_leaderboard(self, leaderboard):
		self.leaderboards.append(leaderboard)

	def remove_leaderboard(self, leaderboard):
		self.leaderboards.remove(leaderboard)

	def notify_leaderboards(self, name, score):
		for board in self.leaderboards:
			board.notify(name, score)




