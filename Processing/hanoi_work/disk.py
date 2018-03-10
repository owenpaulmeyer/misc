class Disk:
    def __str__(self):
        return 'D:' + str(self.sz)
    
    def __init__(self, sz):
        self.sz = sz
    
    def size(self):
        return self.sz