import numpy as np
from operator import itemgetter


class LeaderBoard:

	def __init__(self, length):
		self.length = length
		self.highest = 0.0
		self.lowest = 0.0
		self.board = []

	def notify(self, name, scale, key, score):
		#update the leaderboard
		if score >= self.lowest:
			self.board.append((name, scale, key, score))

		self.board = sorted(self.board, key=itemgetter(3), reverse=True)
		print(self.board)
		if len(self.board) > self.length:
			self.board = self.board[:(self.length)]

		self.highest = self.board[0][1]
		self.lowest = self.board[(len(self.board))-1][1]


	#returns the names and scores in rank order  highest to lowest
	def get_scores(self):
		return self.board

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

	def notify_leaderboards(self, name, scale, key, score):
		for board in self.leaderboards:
			board.notify(name, scale, key, score)
			print(score+5)




