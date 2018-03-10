from disk import *

class Tower:
    def __str__(self):
        return str(map(str,self.tower))
    
    def __init__(self, size, smallest = 1):
        self.smallest = smallest
        self.tower    = self.make_tower(size)
    
    def make_tower(self, size):
        disk_sizes = range(self.smallest, size)
        disk_sizes.reverse()
        tower = []
        for size in disk_sizes:
            disk = Disk(size)
            tower.append(disk)
        return tower

    def push_disk(self, disk):
        self.tower.append(disk)
    
    def pop_disk(self):
        return self.tower.pop()