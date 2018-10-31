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

def processScale(floating_point_time_series, sr):
	#compute Constant-Q Transform
	C = transform(floating_point_time_series, sr, transform_type='Q')
	C = threshold_Q_transform(C, sr)
	
	#we just happen to get an array representing dynamics - saved for later
	dynamics = dynamic_dimension(C)
	
	#gets a list of just the frequencies over time (no intensity info)
	freqs = frequency_dimension(C)
	
	#smooth these frequencies with a median filter to remove artifacts
	freqs = median_filter(freqs, 50)
	
	#count the number of frequencies before pitch changes (duration of note)
	durations = interval_length_array(freqs)
	
	#get only the unique frequencies
	freqs = unique_array(freqs)

	#array of differences between every pitch change
	pitch_changes = arr_differences(freqs)
	
	#form of the scale (w-w-h-w-w-w-h vs. w-h-w-w-h-w-w)
	form = scale_formation(pitch_changes)
	
	#get experimental scores
	pitch_score = rate_pitches(freqs)
	duration_score = statistics.variance(durations)
	
	#get and squash overall score
	total_score = sigmoid((pitch_score + duration_score) * .01)
	print(total_score)
	
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

def threshold_Q_transform(q_transform, sr):
	for column in q_transform.T:
		threshold = np.amax(column)
		column[column < threshold] = 0
		column[column < 1] = 0
	return q_transform
	
def transform(floating_point_time_series, sr, transform_type):
	if (transform_type == 'Q'):
		return np.abs(librosa.cqt(floating_point_time_series, sr=sr, filter_scale=5))
	if (transform_type == 'STFT'):
		return librosa.stft(floating_point_time_series, n_fft=4096)
	if (transform_type == 'Mel'):
		return librosa.feature.melspectrogram(y=floating_point_time_series, sr=sr, n_mels=128, fmax=8000, hop_length=64, n_fft=4096)

#param: any spectrogram looking np array -> array of amplitudes (over time)
def dynamic_dimension(C):
	frequencies = []
	for column in C.T:
		frequencies += [np.amax(column)]
	return frequencies

#param: any spectrogram looking np array -> array of frequencies (over time)
def frequency_dimension(C):
	frequencies = []
	freq_map = get_frequency_map()
	
	for column in C.T:
		frequencies += [column.argmax()]
	for i in range(len(frequencies)):
		frequencies[i] = freq_map[frequencies[i]]
	return frequencies

#param: none -> a mapping of Q-Transform bins to frequencies in Hz
def get_frequency_map():
	freqs = np.empty(85)
	freqs[0] = 5
	for i in range(1, 85):
		freqs[i] = freqs[i - 1] + ((12 - 5) / 84)
	for i in range(0, 85):
		freqs[i] = round(2 ** freqs[i])
	return freqs

#param: any 1D array and sliding window size -> median-smoothed array
def median_filter(arr, window_size):
	for i in range(0, len(arr) - window_size):
		curr_window = []
		for k in range(i, i + window_size):
			curr_window += [arr[k]]
			
		arr[i] = statistics.median_low(curr_window)
	return arr

#param: array -> array with just number of values between unique values
def interval_length_array(arr):
	interval_arr = []
	current_number = 0
	for i in range(len(arr) - 1):
		current_number += 1
		if arr[i] != arr[i + 1]:
			interval_arr += [current_number]
			current_number = 0
	return interval_arr

#param: array -> array with just unique values
def unique_array(arr):
	unique_arr = []
	unique_arr += [arr[0]]
	for i in range(len(arr) - 1):
		if arr[i] != arr[i + 1]:
			unique_arr += [arr[i + 1]]
	return unique_arr

#param: array -> array of differences between arr[i] and arr[i+1]
def arr_differences(arr):
	diff_arr = []
	for i in range(len(arr) - 1):
		cur, nxt = arr[i], arr[i + 1]
		diff_arr += [abs(cur - nxt)]
		
	return diff_arr

#param: list (of unique frequencies) -> array of step size guesses (whole or half)
def scale_formation(unique_freq_differences_arr):
	formation = []
	for dif in unique_freq_differences_arr:
		if 60 < dif < 120:
			formation += ['w']
		elif 0 < dif < 60:
			formation += ['h']
		
	return formation
	
#param: int (a frequency) -> int (ideal next half-step up frequency)
def get_half_step_up(current_note):
	return 1.0595 * current_note
#param: int (a frequency) -> int (ideal next half-step down frequency)
def get_half_step_down(current_note):
	return current_note / 1.0595

#param: int (a frequency) -> list (ideal next four frequencies [ideal half up, ideal whole up, ideal half down, ideal whole down])
def get_ideal_steps(current_note):
	half_up = get_half_step_up(current_note)
	half_down = get_half_step_down(current_note)
	return [half_up, get_half_step_up(half_up), half_down, get_half_step_down(half_down)]

#param: list (of unique frequencies) -> int (number of freqs from each ideal next freq)
def rate_pitches(frequency_array):
	#remove first and last pitch (needs to be deprecated)
	frequency_array = frequency_array[1:-1]
	total_error_distance = 0
	
	for i in range(len(frequency_array) - 1):
		current_note = frequency_array[i]
		actual_next_note = frequency_array[i + 1]
		ideal_next_notes = get_ideal_steps(current_note)
		best_guess_err = float('inf')
		for ideal_note in ideal_next_notes:
			error_distance = abs(actual_next_note - ideal_note)
			if error_distance < best_guess_err:
				best_guess_err = error_distance
		
		total_error_distance += best_guess_err
	return total_error_distance
	

y, sr = librosa.load('/Users/jakesager/Desktop/Senior Fall/OOSE/scales.wav', sr=None)
y = y[:300000]
processScale(y, sr)