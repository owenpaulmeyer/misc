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
int begin = -100;           //start of plotting range
int beginArray = begin*-1;
int end = 88;              //end of plotting range
float pointScale = .1;
float timeScale = 5;
int holderLength = int(end-begin);
int xCount = 0;
float theta=0;

float[][][] holder = new float[holderLength/2][holderLength][3];


void setup() {
  size( 1000, 1000, P3D );
  //noFill();
  lights(); 
  background( 211, 234, 223 );
  back = get();
  stroke( 0 );
  smooth();
  translate(width/2,height/2);//origen to center
  time = begin;
};



void draw() {

  background( 100 ); 
  strokeWeight( 1 );
  stroke(0,255,0);
  line(0,-200,0,0,200,0);
  stroke(255,0,0);
  
  line(-200,0,0,200,0,0);
  stroke(0,0,255);
  line(0,0,-200,0,0,200);
  stroke(0);
  strokeWeight( 1 );
  //frameRate(4);
  noStroke();

  //delay(1000);
  rad = time;//the x term(axis)of the function is used as "time" as the complex term is not constrainable

    if( rad < end) {  //loads the array until the limit is reached
    for(int angle = 0;angle < 361; angle += 3) {
      x = cos( angle*PI/180 ) *rad;
      y = sin( angle*PI/180 ) *rad;

      //y = pointInc;

      z = (x*x) - (y*y);

      complex = 2 * x * y; //complex term of the function sans i; just used as the third axis

      //array to load set of parabolas into; xCount is for a single parabola
      holder[xCount][(angle/3)][0] = x*1;//scaled for display
      holder[xCount][(angle/3)][1] = y*1;
      holder[xCount][(angle/3)][2] = complex*.01;//x here in place of the complex term will give the "saddle shape"
    }
  }

  display();

  //displays the complete set of parabolas showing complex surface


  xCount ++;//increments array for each parabola per "frame" of "time"

  time += timeScale;//advances one frame of time


    camera( mouseX-( width/2 ),mouseY-( height/2 ), 220.0, // eyeX, eyeY, eyeZ
  0.0, 0.0, 0.0, // centerX, centerY, centerZ
  0.0, 1.0, 0.0 ); // upX, upY, upZ
};


void display() {
  int sloop;

  for(int idx=0; idx< holderLength-168; idx +=2) {



    for(int drawIt = 0; drawIt < 121; drawIt ++) {//points of a circle
    fill(255);
 
    if( drawIt % 4 == 0 ){
      fill(0);
 
    }

      beginShape();
      
      vertex(holder[idx][drawIt][0], holder[idx][drawIt][1], holder[idx][drawIt][2]);
      vertex(holder[idx][drawIt+1][0], holder[idx][drawIt+1][1], holder[idx][drawIt+1][2]);
      vertex(holder[idx+1][drawIt+1][0], holder[idx+1][drawIt+1][1], holder[idx+1][drawIt+1][2]);
      vertex(holder[idx+1][drawIt][0], holder[idx+1][drawIt][1], holder[idx+1][drawIt][2]);


      endShape(CLOSE);
    }
  }
}







