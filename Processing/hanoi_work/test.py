class Test:
    def __init__(self, name, function, input, expected_output):
        self.name = name
        self.input = input
        self.function = function
        self.expected_output = expected_output
        
    def run_test(self):
        print self.name
        outcome = self.function(*self.input)
        if outcome == self.expected_output:
            print "  PASS"
        else:
            print "  FAIL"
            print "    expected: ", self.expected_output
            print "    got:      ", outcome
