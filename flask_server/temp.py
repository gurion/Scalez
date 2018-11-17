from processScales import rate_pitches
from processScales import unique_array
good_scale = [440]
for i in range(16):
	for j in range(10):
		good_scale += [good_scale[len(good_scale) - 1]]
	good_scale += [good_scale[len(good_scale) - 1] * 1.0595]
print(good_scale)
print(rate_pitches(unique_array(good_scale)))