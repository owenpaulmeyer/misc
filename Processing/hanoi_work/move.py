class Move:
    def __str__(self):
        return ("\n  start: " + str(self.start_place) +
                "\n  end:   " + str(self.end_place)) 
    
    def __init__(self, start_place, end_place):
        self.start_place = start_place
        self.end_place   = end_place
    
    def start(self):
        return self.start_place
    
    def end(self):
        return self.end_place
