ArrayList<Integer> range(int start, int end) {
  int count = start;
  ArrayList<Integer> range = new ArrayList();
  range.add(start);
  while (count < end) {
    count += 1;
    range.add(count);
  }
  return range;
}
ArrayList<Double> drange(double st, double en, double step) {
    double count = st;
    ArrayList<Double> range = new ArrayList();
    range.add(st);
    while (count < en) {
      count += step;
      range.add(count);
    }
    return range;
}

void makeSpot(double xLoc, double yLoc, double dia, double rot) {
    //# ring()
    ellipse((float)xLoc, (float)yLoc, (float)dia, (float)dia);
}

void makeRing(Ring ring) {
  double scale = ring.radius;
  ArrayList<Double> circles = ring.circles;
  double dia = ring.diameter;
  double rot = ring.rotation;
  dia -= 5;
  int c = 0;
    for (double rad: circles) {
        double y = sin((float)rad) * scale;
        double x = cos((float)rad) * scale;
        strokeWeight(1.8);
        stroke(160, 213, 161);
        if (c == 0) fill(92,137,113);
        else fill(124,37,92);
        makeSpot(x, y, dia, rot);
        ++c;
    }
}

  
Ring ring(double valence, double rotation, double dia) {
    double radius = valence * dia;
    int count = (int)(TAU * radius / dia);
    double inc = (TAU / count);
    ArrayList<Double> circles = drange(0.01 + rotation, (TAU - inc) + rotation, inc); //<>//
    return new Ring(radius, circles, dia, rotation);
}
public class Ring {
  double radius;
  ArrayList<Double> circles;
  double diameter;
  double rotation;
  public Ring(double r, ArrayList<Double> cs, double dia, double rot) {
    radius = r;
    circles = cs;
    diameter = dia;
    rotation = rot;
  }
}
    


void originAtCenter() {
    translate(width / 2, height / 2);
    scale(1,-1);
}
boolean odd(double  n) {
    return n % 2 == 1;
}

int ringCount = 9;
ArrayList<Double> rotations = new ArrayList<Double>();
  
void setup(){
    //originAtCenter();
    for (int n: range(1, ringCount + 1)) {
        rotations.add(new Double(0.1));
    }
    
    smooth();
    size(500, 500);
}

void draw(){
    background(0);
    originAtCenter();
    strokeWeight(1.8);
    stroke(160, 213, 161);
    fill(124,37,92);
    //ellipse(0,0,20,20);


    for (int n : range(1, ringCount)) {
        Double rotation = rotations.get(n);
        rotations.set(n, new Double(rotation + (100.0 / n * 0.0008)));
        //rotations.set(n, new Double(rotation + (n * 0.0005)));
        Ring ring = ring(n, rotation, 25.0);
        makeRing(ring);
    }
}

    