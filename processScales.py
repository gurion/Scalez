'''
OOSE Group 21

Prototype to extract meaningful information from a .wav file input assumed to be a scale.
Call processScale() 

To-Do:
	Better smoothing
	Scale formation recognition
	Scale dynamic recognition
	A ton of other stuff

External Library Requirements (pip install _____):
	matplotlib
	librosa
	numpy

'''

import matplotlib
matplotlib.use('TkAgg')
import matplotlib.pyplot as plt
import librosa
import librosa.display
import numpy as np
import statistics
import math

def processScale(wavFile, sr):
	#compute Constant-Q Transform
	C = transform(wavFile, sr, transform_type='Q')
	C = thresholdQ(C, sr)
	
	#we just happen to get an array representing dynamics - saved for later
	dynamics = dynamicDimension(C)
	
	#gets a list of just the frequencies over time (no intensity info)
	freqs = frequencyDimension(C)
	
	#smooth these frequencies with a median filter to remove artifacts
	freqs = medianFilter(freqs, 50)
	
	#count the number of frequencies before pitch changes (duration of note)
	durations = intervalLengthArray(freqs)
	
	#get only the unique frequencies
	freqs = uniqueArray(freqs)

	#array of differences between every pitch change
	pitch_changes = arrDifferences(freqs)
	
	#form of the scale (w-w-h-w-w-w-h vs. w-h-w-w-h-w-w)
	form = scaleFormation(pitch_changes)
	
	#get experimental scores
	pitchScore = ratePitches(freqs)
	durationScore = statistics.variance(durations)
	
	#get and squash overall score
	totalScore = sigmoid((pitchScore + durationScore) * .01)
	print(totalScore)
	
	#plots whatever you want to plot
	#plt.show()

def sigmoid(x):
	return 1 / (1 + math.exp(-x))

def plotQ(q_transform, sr):
	librosa.display.specshow(librosa.amplitude_to_db(q_transform, ref=np.max), sr=sr, x_axis='time', y_axis='cqt_hz', cmap='viridis')
	#librosa.display.specshow(librosa.power_to_db(S, ref=np.max), y_axis='cqt_note', x_axis='time', cmap='viridis')
	plt.colorbar(format='%+2.0f dB')
	plt.tight_layout()
	plt.show()
	
	#to-do: plot option for mel
	# librosa.display.specshow(librosa.power_to_db(S, ref=np.max), y_axis='mel', fmax=8000, x_axis='time', hop_length=64, sr=sr,cmap='viridis')

def thresholdQ(q_transform, sr):
	for column in q_transform.T:
		threshold = np.amax(column)
		column[column < threshold] = 0
		column[column < 1] = 0
	return q_transform
	
def transform(wavFile, sr, transform_type):
	if (transform_type == 'Q'):
		return np.abs(librosa.cqt(wavFile, sr=sr, filter_scale=5))
	if (transform_type == 'STFT'):
		return librosa.stft(wavFile, n_fft=4096)
	if (transform_type == 'Mel'):
		return librosa.feature.melspectrogram(y=wavFile, sr=sr, n_mels=128, fmax=8000, hop_length=64, n_fft=4096)

#param: any spectrogram looking np array -> array of amplitudes (over time)
def dynamicDimension(C):
	frequencies = []
	for column in C.T:
		frequencies += [np.amax(column)]
	return frequencies

#param: any spectrogram looking np array -> array of frequencies (over time)
def frequencyDimension(C):
	frequencies = []
	freq_map = getFrequencyMap()
	
	for column in C.T:
		frequencies += [column.argmax()]
	for i in range(len(frequencies)):
		frequencies[i] = freq_map[frequencies[i]]
	return frequencies

#param: none -> a mapping of Q-Transform bins to frequencies in Hz
def getFrequencyMap():
	freqs = np.empty(85)
	freqs[0] = 5
	for i in range(1, 85):
		freqs[i] = freqs[i - 1] + ((12 - 5) / 84)
	for i in range(0, 85):
		freqs[i] = round(2 ** freqs[i])
	return freqs

#param: any 1D array and sliding window size -> median-smoothed array
def medianFilter(arr, window_size):
	for i in range(0, len(arr) - window_size):
		curr_window = []
		for k in range(i, i + window_size):
			curr_window += [arr[k]]
			
		arr[i] = statistics.median_low(curr_window)
	return arr

#param: array -> array with just number of values between unique values
def intervalLengthArray(arr):
	intervalArr = []
	currentNumber = 0
	for i in range(len(arr) - 1):
		currentNumber += 1
		if arr[i] != arr[i + 1]:
			intervalArr += [currentNumber]
			currentNumber = 0
	return intervalArr

#param: array -> array with just unique values
def uniqueArray(arr):
	uniqueArr = []
	uniqueArr += [arr[0]]
	for i in range(len(arr) - 1):
		if arr[i] != arr[i + 1]:
			uniqueArr += [arr[i + 1]]
	return uniqueArr

#param: array -> array of differences between arr[i] and arr[i+1]
def arrDifferences(arr):
	diffArr = []
	for i in range(len(arr) - 1):
		cur, nxt = arr[i], arr[i + 1]
		diffArr += [abs(cur-nxt)]
		
	return diffArr

#param: list (of unique frequencies) -> array of step size guesses (whole or half)
def scaleFormation(unique_freq_differences_arr):
	formation = []
	for dif in unique_freq_differences_arr:
		if 60 < dif < 120:
			formation += ['w']
		elif 0 < dif < 60:
			formation += ['h']
		
	return formation
	
#param: int (a frequency) -> int (ideal next half-step up frequency)
def getHalfStepUp(currentNote):
	return 1.0595 * currentNote
#param: int (a frequency) -> int (ideal next half-step down frequency)
def getHalfStepDown(currentNote):
	return currentNote / 1.0595

#param: int (a frequency) -> list (ideal next four frequencies [ideal half up, ideal whole up, ideal half down, ideal whole down])
def getIdealSteps(currentNote):
	halfUp = getHalfStepUp(currentNote)
	halfDown = getHalfStepDown(currentNote)
	return [halfUp, getHalfStepUp(halfUp), halfDown, getHalfStepDown(halfDown)]

#param: list (of unique frequencies) -> int (number of freqs from each ideal next freq)
def ratePitches(frequencyArray):
	#remove first and last pitch (needs to be deprecated)
	frequencyArray = frequencyArray[1:-1]
	totalErrorDistance = 0
	
	for i in range(len(frequencyArray) - 1):
		currentNote = frequencyArray[i]
		actualNextNote = frequencyArray[i + 1]
		idealNextNotes = getIdealSteps(currentNote)
		bestGuessErr = float('inf')
		for idealNote in idealNextNotes:
			errorDistance = abs(actualNextNote - idealNote)
			if errorDistance < bestGuessErr:
				bestGuessErr = errorDistance
		
		totalErrorDistance += bestGuessErr
	return totalErrorDistance
	

y, sr = librosa.load('/Users/jakesager/Desktop/Senior Fall/OOSE/scales.wav', sr=None)
y = y[:300000]
processScale(y, sr)