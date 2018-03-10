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

float[][][] holder = new float[holderLength][holderLength][4];


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
  x = time;
  populate();
  //
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


  //the x term(axis)of the function is used as "time" as the complex term is not constrainable



  //rotation( .01,1,3);
 //rotation( .01,1,2);
 rotation( .01,2,3);
  display();





  //displays the complete set of parabolas showing complex surface


  //increments array for each parabola per "frame" of "time"




    camera( mouseX-( width/2 ),mouseY-( height/2 ), 220.0, // eyeX, eyeY, eyeZ
  0.0, 0.0, 0.0, // centerX, centerY, centerZ
  0.0, 1.0, 0.0 ); // upX, upY, upZ
};


void populate() {
  x = time;//the x term(axis)of the function is used as "time" as the complex term is not constrainable
  for(int spak = 0; spak < 176; spak ++) {
    x = time;
    //if( x < end) {  //loads the array until the limit is reached
      for(float pointInc = begin; pointInc < end; pointInc += pointScale ) {
        y = pointInc;

        //z = (x*x) - (y*y);
       //z = x*x*x - 3*x*y*y;
       z= sqrt( x*x-y );

        //complex = 2 * x * y; //complex term of the function sans i; just used as the third axis
        complex = -y*y*y + 3*x*x*y;

        //array to load set of parabolas into; xCount is for a single parabola
        holder[xCount][int(pointInc + beginArray)][0] =x*1;//scaled for display x*1;
        holder[xCount][int(pointInc + beginArray)][1] = y*1;//y*1;
        holder[xCount][int(pointInc + beginArray)][2] = z*1;//z*.01;
        holder[xCount][int(pointInc + beginArray)][3] = complex*.0001;//complex*.01;
      }
   // }
 

  xCount ++;//increments array for each parabola per "frame" of "time"

  time += timeScale;//advances one frame of time
  }
}

void display() {
  for(int idx=0; idx< holderLength; idx ++) {
    beginShape();
    for(int drawIt = 0; drawIt < holderLength; drawIt ++) {
      vertex(holder[idx][drawIt][0], holder[idx][drawIt][2], holder[idx][drawIt][1]);
    }
    endShape();
  }
  // print("stop");
}



void rotation(float theta, int axisA, int axisB) {
  for(int surface=0; surface < holderLength; surface++) {
    for(int lines=0; lines < holderLength; lines++) {

      float pass_x = ( holder[ surface ][ lines ][ axisA ] * cos( theta ) )     
        + ( holder[ surface ][ lines ][ axisB ] * -sin( theta ) );       


      float pass_y = ( holder[ surface ][ lines ][ axisA ] * sin( theta ) )     
        + ( holder[ surface ][ lines ][ axisB ] *  cos( theta ) );

      holder[ surface ][ lines ][ axisA ] = pass_x;
      holder[ surface ][ lines ][ axisB ] = pass_y;
    }
  }
}

