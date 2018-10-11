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
from collections import OrderedDict

def processScale(wavFile, sr):
	C = transform(wavFile, sr, transform_type='Q')
	C = thresholdQ(C, sr)
	
	dynamics = dynamicDimension(C)
	freqs = frequencyDimension(C)
	freqs = medianFilter(freqs, 50)
	#freqs = list(OrderedDict.fromkeys(freqs))
	scaleFormation(freqs)
	plt.stem(freqs)
	plt.show()

	#plotQ(C, sr)

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
		
def dynamicDimension(C):
	frequencies = []
	for column in C.T:
		frequencies += [np.amax(column)]
	return frequencies

def frequencyDimension(C):
	frequencies = []
	freq_map = getFrequencyMap()
	
	for column in C.T:
		frequencies += [column.argmax()]
	for i in range(len(frequencies)):
		frequencies[i] = freq_map[frequencies[i]]
	return frequencies

def getFrequencyMap():
	freqs = np.empty(85)
	freqs[0] = 5
	for i in range(1, 85):
		freqs[i] = freqs[i - 1] + ((12 - 5) / 84)
	for i in range(0, 85):
		freqs[i] = round(2 ** freqs[i])
	return freqs

def medianFilter(arr, window_size):
	for i in range(0, len(arr) - window_size):
		curr_window = []
		for k in range(i, i + window_size):
			curr_window += [arr[k]]
			
		arr[i] = statistics.median(curr_window)
	return arr

def scaleFormation(arr):
	formation = []
	unique_arr = []
	unique_arr += [arr[0]]
	for i in range(len(arr) - 1):
		if arr[i] != arr[i + 1]:
			unique_arr += [arr[i + 1]]

	print(unique_arr)
	
	for i in range(len(unique_arr) - 1):
		cur, nxt = unique_arr[i], unique_arr[i + 1]
		dif = abs(cur-nxt)
		if dif > 25 and dif < 45:
			formation += ['whole']
		elif dif > 10 and dif < 25:
			formation += ['half']
		
	print(formation)
	
#	print(arr)
#	i = 0
#	while (i < len(arr) - 1):
#		cur, nxt = arr[i], arr[i + 1]
#		if cur != nxt:
#			formation += [abs(cur-nxt)]
#		i += 1
#	print(formation)

y, sr = librosa.load('/Users/jakesager/Desktop/Senior Fall/OOSE/scales.wav', sr=None)
y = y[:300000]
processScale(y, sr)