#the recording is kind of a dummy object, it doesnt do much right now except hold values
class recording:
    def __init__(self, score, isPublic, instrument, idnum):
        self.score = score
        self.isPublic = isPublic
        self.instrument = instrument
        self.idnum = idnum

class scorer:
    #score depending on the scale type?
    def __init__(scaletype):
        self.scaletype = scaletype
    
    #this will score the audiorecording
    def score(audio):
        return 0.99



