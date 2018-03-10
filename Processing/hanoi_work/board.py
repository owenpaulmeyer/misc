from tower import *


class Board:
    def __str__(self):
        string = ('\n  Red   \n    ' + str(self.red) +
                  '\n  Green \n    ' + str(self.green) +
                  '\n  Blue  \n    ' + str(self.blue))
        return string
        
    def __init__(self):
            self.red   = Tower(0)
            self.green = Tower(0)
            self.blue  = Tower(0)
        
    def make_set_tower(self, place, size, smallest = 1):
        tower = Tower(size, smallest)
        self.set_tower(tower, place)
        return self
        
    def set_tower(self, tower, place):
        if place == 'red':
            self.red   = tower
        elif place == 'green':
            self.green = tower
        elif place == 'blue':
            self.blue  = tower
        return self
        
    def get_tower(place):
        if place == 'red':
            return self.red
        elif place == 'green':
            return self.green
        elif place == 'blue':
            return self.blue
        
        
    def set_disk(self, disk, place):
        if place == 'red':
            self.red.push_disk(disk)
        elif place == 'green':
            self.green.push_disk(disk)
        elif place == 'blue':
            self.blue.push_disk(disk)
        return self