import processing.opengl.*;

PImage back;
float z, y, x;
float time;
float complex;
int begin = -80;
int beginArray = begin*-1;
int end = 80;
float pointScale = .1;
float timeScale = 1;
float holderLength = (end-begin);
int xCount = 0;

float timeLength = (end-begin)/timeScale;
//float[][][] holder = new float[int(timeLength)][int(holderLength)][3];
float[][] holder = new float[int(holderLength)][3];

void setup() {
  size( 1000, 1000, P3D );
  noFill();
  lights(); 
  background( 211, 234, 223 );
  back = get();
  stroke( 0 );
  rectMode(CENTER);
  smooth();
  translate(width/2,height/2);
  time = begin;
};



void draw() {
 // translate(width/2,height/2);
  background( back );
//  rect(0,0,20,20);
//  
//  strokeWeight( 1 );
//  stroke(255,0,0);
//  line(0,1000*-1,0,0,1000,0);
//  stroke(0,255,0);
//  line(1000*-1,0,0,1000,0,0);
//  stroke(0,0,255);
//  line(0,0,1000*-1,0,0,1000*-1);
  stroke(0);
  strokeWeight( 2 );


  x = time;


  
  if( x < end) {
    for(float pointInc = begin; pointInc < end; pointInc += pointScale ) {
      y = pointInc;

      z = (x*x) - (y*y);
      // println("z " + z );

      complex = 2 * x * y;

      // point(y,z,complex);

      //    holder[xCount][int(pointInc + beginArray)][0] = y;
      //    holder[xCount][int(pointInc + beginArray)][1] = z;
      //    holder[xCount][int(pointInc + beginArray)][2] = complex;
      holder[int(pointInc + beginArray)][0] = y*.05;
      holder[int(pointInc + beginArray)][1] = z*.05;
      holder[int(pointInc + beginArray)][2] = complex*.05;
    }
  }
  //for(int idx=0; idx< 40; idx ++) {
    beginShape();
    for(int drawIt = 0; drawIt < holder.length; drawIt ++) {
      //    vertex(holder[idx][drawIt][0], holder[idx][drawIt][1], holder[idx][drawIt][2]);
      vertex(holder[drawIt][0], holder[drawIt][1], holder[drawIt][2]);
    }
    endShape();
 // }




    println("x: " + x);
    println("y: " + y);
    println("z: " + z);
    println("complex: " + complex);
  //






  xCount ++;
  time += timeScale;


  camera( mouseX-( width/2 ),mouseY-( height/2 ), 220.0, // eyeX, eyeY, eyeZ
  0.0, 0.0, 0.0, // centerX, centerY, centerZ
  0.0, 1.0, 0.0 ); // upX, upY, upZ
};

