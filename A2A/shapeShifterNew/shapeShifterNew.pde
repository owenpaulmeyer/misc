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
int iCount = 0;
float span = end-begin;
float spanInc;
float iterate =0;
float compleX;

float[][][] holder = new float[holderLength][holderLength][3];


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

};



void draw() {
    background( back ); 
    strokeWeight( 1 );
    stroke(0,255,0);
    line(0,-200,0,0,200,0);
    stroke(255,0,0);
    line(-200,0,0,200,0,0);
    stroke(0,0,255);
    line(0,0,-200,0,0,200);
  stroke(0);
  strokeWeight( 1 );
// println("iterate  " + ((176-iterate)/176)); 
  spanInc = span / ( xCount+2 );

  x = time;//the x term(axis)of the function is used as "time" as the complex term is not constrainable
iterate=0;
compleX = 2*x*(-88+xCount);
  if( x < end) {  //loads the array until the limit is reached
    for(float pointInc = begin; pointInc < end; pointInc += 1 ) {
      y = pointInc;

      z = (x*x) - (y*y);
      
      //complex = ((176-iterate)/176)*(y+45);//-(88-iterate);
      //complex = y * (176-iterate)/176;
      //complex = ((176-iterate)/176)*(y-40);
      //complex = ( ((176-iterate)/176)*(y-148)+(88-iterate) )+88;
      complex = compleX+ y*x;
     // complex = 
  

      //array to load set of parabolas into; xCount is for a single parabola
      holder[xCount][int(pointInc + beginArray)][0] = complex*.01;//scaled for display
      holder[xCount][int(pointInc + beginArray)][1] = y*1;
      holder[xCount][int(pointInc + beginArray)][2] = z*.01;//x here in place of the complex term will give the "saddle shape"
 iterate+=10;
    }
  }

  //displays the complete set of parabolas showing complex surface
  for(int idx=0; idx< holderLength; idx ++) {
    beginShape();
    for(int drawIt = 0; drawIt < holderLength; drawIt ++) {
      vertex(holder[idx][drawIt][0], holder[idx][drawIt][1], holder[idx][drawIt][2]);
    }
    endShape();
  }

  xCount ++;//increments array for each parabola per "frame" of "time"
  iCount += 100;

  time += timeScale;//advances one frame of time


  camera( mouseX-( width/2 ),mouseY-( height/2 ), 220.0, // eyeX, eyeY, eyeZ
  0.0, 0.0, 0.0, // centerX, centerY, centerZ
  0.0, 1.0, 0.0 ); // upX, upY, upZ
};





//     // if(time < 0)
//      compleX = int((2*x*y)/100); //complex term of the function sans i; just used as the third axis
//      
//      complex = map(compleX, 154,-154, 154-iterate, -154+iterate);
//     // if(time > 0)
//     // complex = map( 2*x*y, 88, -88, 88 - iterate, -88 + iterate );
//      iterate +=4;

