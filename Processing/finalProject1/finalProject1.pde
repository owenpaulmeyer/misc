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
int begin = -130;           //start of plotting range
int beginArray = begin*-1;
int end = 88;              //end of plotting range
float pointScale = .1;
float timeScale = 5;
int holderLength = int(end-begin);
int xCount = 0;
float theta=0;
int strobe=1;
int strobeStart=1;
int phase = 8;

float[][][] holder = new float[20][121][4];
float[][][] holderB = new float[20][121][4];


void setup() {
 // background(0);
  size( 1000, 1000, P3D );
  //noFill();
  lights(); 
 // background( 211, 234, 223 );
  back = get();
  stroke( 0 );
  smooth();
  translate(width/2,height/2);//origen to center
  time = begin;
  populate();
  time = begin;
  xCount = 0;
    populateB();
   // rotationB( -.8,3,0);
  print(holderLength-168);
};



void draw() {

  background( 131,178,171 ); 
  strokeWeight( 1 );
  stroke(0,255,0);
 // line(0,-200,0,0,200,0);
  stroke(255,0,0);

  //line(-200,0,0,200,0,0);
  stroke(0,0,255);
 // line(0,0,-200,0,0,200);
  stroke(0);
  strokeWeight( 1 );
  //frameRate(400);
  noStroke();

  //delay(1000);
  //advances one frame of time

    //rotation( .01,1,3);
    
 /// if(strobe == -1 )strobeStart = 0;  
 // if(strobe == 1 )strobeStart = 1;
//  if(frameCount % 10 == 0 )
//  strobe = 1;
//  if(frameCount % 20 == 0 )
//  strobe = 2;
//  if(frameCount % 30 == 0 )
//  strobe = 3;
//  if(frameCount % 40 == 0 )
//  strobe = 4;
  
  
  if(frameCount %4 == 0){
    strobe++;
    strobeStart++;
    if(strobe == phase)strobe=0;
  }
//   if(frameCount %4 == 0){
//    strobeStart++;
//    if(strobeStart == 120)strobe=1;
//  }
 
    
  
  rotation( .008,3,0);
  rotationB(-.008,2,0);
  rotationB(.008,3,0);
  display();
  displayB();
  

  camera( mouseX-( width/2 ),mouseY-( height/2 ), 220.0, // eyeX, eyeY, eyeZ
  0.0, 0.0, 0.0, // centerX, centerY, centerZ
  0.0, 1.0, 0.0 ); // upX, upY, upZ
};


void display() {
  int sloop;

  for(int idx=1; idx< 19; idx +=2) {

    for(int drawIt = 0; drawIt < 120; drawIt ++) {//points of a circle
      noFill();

      if( (drawIt + strobe) % phase == 0 ) {
        fill(255-(idx*12));
      }
//      if( (drawIt + strobeStart) % 120 == 0 ) {
//        fill(0,0,255);
//      }

      beginShape();

      vertex(holder[idx][drawIt][3], holder[idx][drawIt][1], holder[idx][drawIt][2]);
      vertex(holder[idx][drawIt+1][3], holder[idx][drawIt+1][1], holder[idx][drawIt+1][2]);
      vertex(holder[idx+1][drawIt+1][3], holder[idx+1][drawIt+1][1], holder[idx+1][drawIt+1][2]);
      vertex(holder[idx+1][drawIt][3], holder[idx+1][drawIt][1], holder[idx+1][drawIt][2]);


      endShape(CLOSE);
    }
  }
}

void displayB() {
  int sloop;

  for(int idx=1; idx< 19; idx +=2) {

    for(int drawIt = 0; drawIt < 120; drawIt ++) {//points of a circle
      noFill();

      if( (drawIt + strobeStart) % phase == 0 ) {
        fill(0+(idx*12));
      }
//      if( (drawIt + strobeStart) % 120 == 0 ) {
//        fill(0,0,255);
//      }

      beginShape();

      vertex(holderB[idx][drawIt][3], holderB[idx][drawIt][1], holderB[idx][drawIt][2]);
      vertex(holderB[idx][drawIt+1][3], holderB[idx][drawIt+1][1], holderB[idx][drawIt+1][2]);
      vertex(holderB[idx+1][drawIt+1][3], holderB[idx+1][drawIt+1][1], holderB[idx+1][drawIt+1][2]);
      vertex(holderB[idx+1][drawIt][3], holderB[idx+1][drawIt][1], holderB[idx+1][drawIt][2]);


      endShape(CLOSE);
    }
  }
}





void populate() {
  //the x term(axis)of the function is used as "time" as the complex term is not constrainable

    for(int circles=0; circles< 20; circles++) {
    rad = time;
    //if( rad < end) {  //loads the array until the limit is reached
    for(int angle = 0;angle < 361; angle += 1) {
      x = cos( angle*PI/180 ) *rad;
      y = sin( angle*PI/180 ) *rad;

      //y = pointInc;

      z = (x*x) - (y*y);
      //z = x*x*x - 3*x*y*y;

      complex = 2 * x * y; //complex term of the function sans i; just used as the third axis
     // complex = -y*y*y + 3*x*x*y;

      //array to load set of parabolas into; xCount is for a single parabola
      holder[xCount][(angle/3)][0] = x*1;//scaled for display
      holder[xCount][(angle/3)][1] = y*1;
      holder[xCount][(angle/3)][3] = z*.01;//x here in place of the complex term will give the "saddle shape"
      holder[xCount][(angle/3)][2] = complex*.01;



      //displays the complete set of parabolas showing complex surface
    }
    xCount ++;//increments array for each parabola per "frame" of "time"

    time += timeScale;
  }
}

void populateB() {
  //the x term(axis)of the function is used as "time" as the complex term is not constrainable

    for(int circles=0; circles< 20; circles++) {
    rad = time;
    //if( rad < end) {  //loads the array until the limit is reached
    for(int angle = 0;angle < 361; angle += 1) {
      x = cos( angle*PI/180 ) *rad;
      y = sin( angle*PI/180 ) *rad;

      //y = pointInc;

      z = (x*x) - (y*y);
      //z = x*x*x - 3*x*y*y;

      complex = 2 * x * y; //complex term of the function sans i; just used as the third axis
     // complex = -y*y*y + 3*x*x*y;

      //array to load set of parabolas into; xCount is for a single parabola
      holderB[xCount][(angle/3)][0] = x*1;//scaled for display
      holderB[xCount][(angle/3)][1] = y*1;
      holderB[xCount][(angle/3)][3] = z*.01;//x here in place of the complex term will give the "saddle shape"
      holderB[xCount][(angle/3)][2] = complex*.01;



      //displays the complete set of parabolas showing complex surface
    }
    xCount ++;//increments array for each parabola per "frame" of "time"

    time += timeScale;
  }
}


void rotation(float theta, int axisA, int axisB) {
  for(int surface=0; surface < 20; surface++) {
    for(int lines=0; lines < 121; lines++) {

      float pass_x = ( holder[ surface ][ lines ][ axisA ] * cos( theta ) )     
        + ( holder[ surface ][ lines ][ axisB ] * -sin( theta ) );       


      float pass_y = ( holder[ surface ][ lines ][ axisA ] * sin( theta ) )     
        + ( holder[ surface ][ lines ][ axisB ] *  cos( theta ) );

      holder[ surface ][ lines ][ axisA ] = pass_x;
      holder[ surface ][ lines ][ axisB ] = pass_y;
    }
  }
}

void rotationB(float theta, int axisA, int axisB) {
  for(int surface=0; surface < 20; surface++) {
    for(int lines=0; lines < 121; lines++) {

      float pass_x = ( holderB[ surface ][ lines ][ axisA ] * cos( theta ) )     
        + ( holderB[ surface ][ lines ][ axisB ] * -sin( theta ) );       


      float pass_y = ( holderB[ surface ][ lines ][ axisA ] * sin( theta ) )     
        + ( holderB[ surface ][ lines ][ axisB ] *  cos( theta ) );

      holderB[ surface ][ lines ][ axisA ] = pass_x;
      holderB[ surface ][ lines ][ axisB ] = pass_y;
    }
  }
}

