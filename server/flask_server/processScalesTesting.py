import nose
import librosa
import statistics
from processScales import processScale
from processScales import rate_pitches
from processScales import unique_array
from processScales import rate_durations
from processScales import interval_length_array
from processScales import median_filter
from processScales import unique_array
from processScales import normalize_pitch_error
from processScales import normalize_duration_error
from processScales import normalize_dynamics_error

sample_input, sr = librosa.load('/Users/jakesager/Desktop/Senior Fall/OOSE/scales.wav', sr=None)
sample_input = sample_input[:300000]

def test_wav_input():
	assert type(processScale(sample_input, sr)) == float

def test_short_input():
	assert type(processScale([0], sr)) == float
	assert type(processScale([], sr)) == float

def test_bad_sr():
	assert type(processScale(sample_input, -1)) == float
	assert type(processScale(sample_input, 0)) == float

def test_input_type():
	assert type(processScale('bad input', sr)) == float
	assert type(processScale(sample_input, 'bad sr')) == float
	
def test_good_scale_pitch():
	good_scale = [440]
	for i in range(16):
		for j in range(10):
			good_scale += [good_scale[len(good_scale) - 1]]
		good_scale += [good_scale[len(good_scale) - 1] * 1.0595]
	good_scale = unique_array(good_scale)
	assert rate_pitches(good_scale) == 0.0
	
def test_bad_scale_pitch():
	bad_scale = [440]
	for i in range(16):
		for j in range(10):
			bad_scale += [bad_scale[len(bad_scale) - 1]]
		bad_scale += [bad_scale[len(bad_scale) - 1] * 1.3]
	bad_scale = unique_array(bad_scale)
	assert rate_pitches(bad_scale) > 500
	assert rate_durations(interval_length_array(bad_scale)) < 1

def test_good_scale_dur():
	good_scale = [440]
	for i in range(16):
		for j in range(10):
			good_scale += [good_scale[len(good_scale) - 1]]
		good_scale += [good_scale[len(good_scale) - 1] * 1.0595]
	good_scale = unique_array(good_scale)
	assert rate_durations(interval_length_array(good_scale)) < 1

def test_non_scale_like_input():
	print()
	input_a, sr_a = librosa.load('/Users/jakesager/Desktop/Senior Fall/OOSE/2018-group-21/backend/flask_server/test audio/happy.wav', sr=None)
	input_b, sr_b = librosa.load('/Users/jakesager/Desktop/Senior Fall/OOSE/2018-group-21/backend/flask_server/test audio/samantha(monotone).wav', sr=None)
	input_c, sr_c = librosa.load('/Users/jakesager/Desktop/Senior Fall/OOSE/2018-group-21/backend/flask_server/test audio/wavenet(monotone).wav', sr=None)
	assert type(processScale(input_a, sr_a)) == float
	assert type(processScale(input_b, sr_b)) == float
	assert type(processScale(input_c, sr_c)) == float
	
def test_median_filter():
	assert median_filter([], 2) == []
	assert median_filter([0], 2) == [0]
	assert median_filter([0], 5) == [0]
	assert median_filter([0,1,0], 2) == [0,1,0]
	assert median_filter([0,0,0,0,0,0,0,1,0,0], 2) == [0,0,0,0,0,0,0,0,0,0]
	assert median_filter([0,0,0,0,0,0,0,1,0,0,0], 5) == [0,0,0,0,0,0,0,0,0,0,0]

def test_unique_array():
	assert unique_array([0]) == [0]
	assert unique_array([1,1,1,1,1]) == [1]
	assert unique_array([1,1,1,2,2]) == [1,2]
	assert unique_array([1,1,1,1,1,2,2,1]) == [1,2,1]
	assert unique_array([]) == []

def test_normalization():
	assert normalize_pitch_error(0) == 0.0
	assert normalize_pitch_error(float('inf')) == 1.0
	assert normalize_duration_error(0, 12000) == 0.0
	assert normalize_duration_error(float('inf'), 12000) == 1.0
	assert normalize_dynamics_error(0) == 0.0
	assert normalize_dynamics_error(float('inf')) == 1.0