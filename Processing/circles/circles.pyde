def drange(st, en, step):
    count = st
    rng = [st]
    while count < en:
        count += step
        rng.append(count)
    return rng

def makeSpot(xLoc, yLoc, dia, rot):
    # ring()
    ellipse(xLoc, yLoc, dia, dia)

def makeRing(scale, circles, dia, rot):
    dia -= 5
    for rad in circles:
        y = sin(rad) * scale
        x = cos(rad) * scale
        strokeWeight(1.8)
        stroke(160, 213, 161)
        fill(124,37,92)
        makeSpot(x, y, dia, rot)

def ring(valence, rotation, dia = 25):
    radius = valence * dia
    count = int(TAU * radius / dia)
    inc = TAU / count
    circles = drange(0.01 + rotation, (TAU - inc) + rotation, inc)
    return (radius, circles, dia, rotation)
    


def originAtCenter():
    translate(width / 2, height / 2)
    scale(1,-1)

def odd(n):
    return n % 2 == 1


ringCount = 10
rotations = {}
        
def setup():
    for n in range(1, ringCount + 1):
        rotations[n] = .1
    print("rtns: ", rotations)
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
    ellipse(0,0,20,20)
    

    for n in range(1, ringCount):
        rotation = rotations[n]
        rotations[n] = rotation + (100 / n * 0.0005)
        # rotations[n] = rotation + (n * 0.002)
        circles = ring(n, rotation)
        # makeRing(radius, circles, dia, rotation)
        makeRing(*circles)
    

    