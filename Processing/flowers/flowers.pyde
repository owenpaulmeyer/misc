def drange(st , en, step):
    count = st
    range = [st]
    while count < en:
        count += step
        range.append(round(count, 4))
    return range

def makeSpots(xLoc, yLoc, dia, rot):
    innerRing = ring(1, rot * -1, dia)
    dia = 5
    for rad in innerRing[1]:
        y = sin(rad) * 8
        x = cos(rad) * 8
        strokeWeight(1.8)
        stroke(160, 213, 161)
        fill(124,37,92)
        ellipse(xLoc + x, yLoc + y, dia, dia)

def makeRing(scl, circles, dia, rot):
    dia = 8
    for rad in circles:
        y = sin(rad) * scl
        x = cos(rad) * scl
        strokeWeight(1.8)
        stroke(160, 213, 161)
        fill(124,37,92)
        makeSpots(x, y, dia, rot)
        # ellipse(xLoc, yLoc, dia, dia)

def ring(valence, rotation, dia = 25):
    radius = valence * float(dia)
    count = int(TAU * radius / dia)
    inc = TAU / count
    circles = drange(0.01 + rotation, (TAU - inc) + rotation, inc)
    return (radius, circles, dia, rotation)
    


def originAtCenter():
    translate(width / 2, height / 2)
    scale(1,-1)

def odd(n):
    return n % 2 == 1


ringCount = 7
rotations = {}
        
def setup():
    for n in range(1, ringCount + 1):
        rotations[n] = .1
    print(">>>", drange(2.3, 4, .1))
    smooth()
    size(500, 500)
    # frameRate(200)
    
def draw():
    global rotations, ringCount
    background(0)
    originAtCenter()
    strokeWeight(1.8)
    stroke(160, 213, 161)
    fill(124,37,92)
    # ellipse(0,0,20,20)
    

    for n in range(1, ringCount):
        rotation = rotations[n]
        rotations[n] = rotation + (100 / n * 0.0003)
        # rotations[n] = rotation + (n * 0.002)
        circles = ring(n, rotation)
        # makeRing(radius, circles, dia, rotation)
        makeRing(*circles)
    

    