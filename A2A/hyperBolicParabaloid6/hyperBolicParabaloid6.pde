//Owen Meyer ( first year student, beggining programmer (not advanced) )
//Complex Function
//Sans the complex class structure
//traces a parabola over a short period of time through "complex space"



import processing.opengl.*;

PImage back;
float z, y, x;
float time;
float complex;    //the complex term (won't be necessary to use i)
int begin = -88;           //start of plotting range
int beginArray = begin*-1;
int end = 88;              //end of plotting range
float pointScale = .1;
float timeScale = 1;
int holderLength = int(end-begin);
int xCount = 0;

float[][][] holder = new float[holderLength][holderLength][3];


void setup() {
  size( 1000, 1000, P3D );
  noFill();
  lights(); 
  background( 211, 234, 223 );
  back = get();
  stroke( 0 );
  smooth();
  translate(width/2,height/2);   //origin to center
  time = begin;
};



void draw() {

  background( back );
  //axis; aren't debugged 
  //  strokeWeight( 1 );
  //  stroke(255,0,0);
  //  line(0,1000*-1,0,0,1000,0);
  //  stroke(0,255,0);
  //  line(1000*-1,0,0,1000,0,0);
  //  stroke(0,0,255);
  //  line(0,0,1000*-1,0,0,1000*-1);
  stroke(0);
  strokeWeight( 1 );


  x = time;//the x term(axis)of the function is used as "time" as the complex term is not constrainable

  if( x < end) {  //loads the array until the limit is reached
    for(float pointInc = begin; pointInc < end; pointInc += pointScale ) {
      y = pointInc;

      z = (x*x) - (y*y);

      complex = 2 * x * y; //complex term of the function sans i; just used as the third axis

      //array to load set of parabolas into; xCount is for a single parabola
      holder[xCount][int(pointInc + beginArray)][0] = y;//scaled for display
      holder[xCount][int(pointInc + beginArray)][1] = z*.01;
      holder[xCount][int(pointInc + beginArray)][2] = complex*.01;//x here in place of the complex term will give the "saddle shape"
    }
  }

  //displays the complete set of parabolas showing complex surface
  for(int idx=0; idx< holderLength; idx ++) {
   // beginShape();
    for(int drawIt = 0; drawIt < holderLength; drawIt ++) {
      point(holder[idx][drawIt][0], holder[idx][drawIt][1], holder[idx][drawIt][2]);
    }
   // endShape();
  }

  xCount ++;//increments array for each parabola per "frame" of "time"

  time += timeScale;//advances one frame of time


  camera( mouseX-( width/2 ),mouseY-( height/2 ), 220.0, // eyeX, eyeY, eyeZ
  0.0, 0.0, 0.0, // centerX, centerY, centerZ
  0.0, 5.0, 0.0 ); // upX, upY, upZ
};

