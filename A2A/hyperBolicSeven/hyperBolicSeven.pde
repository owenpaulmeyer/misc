//Owen Meyer
//Complex Function
//Sans the complex class structure
//traces a parabola over a short period of time through "complex space"
//y = x²  with a complex for x becomes
//z = (x + yi)² becomes
//z = x² - y² + 2xyi
//x and y are inputs giving the z and i terms
//the surface is graphed as x is constrained per parabola while y iterates
//then x advances to get the next parabola in the surface



import processing.opengl.*;

PImage back;
float z, y, x, rad;
float time;
float complex;    //the complex term (won't be necessary to use i)
int begin = -98;           //start of plotting range
int beginArray = begin*-1;
int end = 98;              //end of plotting range
float pointScale = .1;
float timeScale = 5;
int holderLength = int(end-begin);
int xCount = 0;
float theta=0;
int inc=0;
int yCount=0;
int squirle=353;
int spiraLength=4000;

float[][][] holder = new float[squirle][spiraLength][3];


void setup() {
  size( 1000, 1000, P3D );
  noFill();
  lights(); 
  background( 211, 234, 223 );
  back = get();
  stroke( 0 );
  smooth();
  translate(width/2,height/2);//origen to center
  time = begin;
  rad=1;
};



void draw() {

  background( back ); 
  strokeWeight( 1 );
  stroke(0,255,0);
  line(0,-200,0,0,200,0);
  stroke(255,0,0);
  line(-200,0,0,200,0,0);
  stroke(0,0,255);
  // line(0,0,-200,0,0,200);
  stroke(0);
  strokeWeight( 1 );
  frameRate(500);

  //delay(1000);
  // rad = time;//the x term(axis)of the function is used as "time" as the complex term is not constrainable
  //  inc = 0;
  //  x=0;
  //  y=0;
  //  rad=1;
  if( xCount < 1) {  //loads the array until the limit is reached
    //  if( rad < 0 ){
    //    stroke(25, 252, 232); 
    //  }
    for(int turn=0; turn<squirle; turn++ ) {
      inc=0;
      rad=0;
      for(int angle = 0;angle < spiraLength; angle += 1) {

        x = cos( (angle+turn)*PI/180 ) *rad;
        y = sin( (angle+turn)*PI/180 ) *rad;



        z = (x*x) - (y*y);


        complex = 2 * x * y; //complex term of the function sans i; just used as the third axis

        //array to load set of parabolas into; xCount is for a single parabola
        holder[turn][inc][0] = complex*.001;//scaled for display
        holder[turn][inc][1] = y*.4;
        holder[turn][inc][2] = z*.001;//x here in place of the complex term will give the "saddle shape"
        //  println("inc: " + inc);0
        rad+=.1;
        inc ++;
      }
    }
  }
  //displays the complete set of parabolas showing complex surface

    beginShape();
    for(int drawIt = 0; drawIt < spiraLength; drawIt ++) {
      curveVertex(holder[yCount][drawIt][0], holder[yCount][drawIt][1], holder[yCount][drawIt][2]);
    }
    endShape();
 

  xCount ++;//increments array for each parabola per "frame" of "time"

  time += timeScale;//advances one frame of time
yCount++;
if(yCount == squirle)yCount=0;
println("ycount: " + yCount);
    camera( mouseX-( width/2 ),mouseY-( height/2 ), 220.0, // eyeX, eyeY, eyeZ
  0.0, 0.0, 0.0, // centerX, centerY, centerZ
  0.0, 1.0, 0.0 ); // upX, upY, upZ
};

