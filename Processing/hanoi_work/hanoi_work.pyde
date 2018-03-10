
from tower import *
from board import *
from move  import *
from test  import *
    
tower_height = 10
board = Board().make_set_tower('red', tower_height)

def make_move(board, move):
    # print 'mmBoard: ', board
    # print 'mmMove:  ', move
    # calling = <some tower>.push_disk(<some disk>)
    return None

def plus(a, b):
    return a + b

# test1 = Test("plus should sum inputs", plus, [1, 2], 4)
# test1.run_test()

"TEST: making a move"
starting_board = Board().make_set_tower('red', 10)
changed_board  = (Board()
    .make_set_tower('red', 10, 2)
    .set_disk(Disk(1), 'blue'))
move = Move('red', 'blue')
print "STARTING: ", str(starting_board)
test2 = Test("make_move takes a board, a starting place and an ending_place and returns the board after the move",
              make_move,
              [starting_board, move],
              changed_board)

test2.run_test()


