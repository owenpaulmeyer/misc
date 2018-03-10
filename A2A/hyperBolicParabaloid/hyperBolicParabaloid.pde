import processing.opengl.*;

PImage back;
float z, y, x;
float time;
float complex;
int begin = -20;
float beginArray = begin*-1;
int end = 20;
float pointScale = .1;
float timeScale = .1;
float holderLength = (end-begin)/pointScale;

float timeLength = (end-begin)/timeScale;
float[][][] holder = new float[int(timeLength)][int(holderLength)][3];

void setup() {
  size( 900, 900, P3D );
  noFill();
  lights(); 
  background( 211, 234, 223 );
  back = get();
  stroke( 0 );
  strokeWeight( 2 );
  smooth();
  translate(width/2,height/2);
  time = begin;
};



void draw() {
  background( back );
 
  
  x = time;
  
  
  //beginShape();
  if( x < 20){
  for(float pointInc = begin; pointInc < end; pointInc += pointScale ){
    y = pointInc;
    
    z = (x*x) - (y*y);
    
    complex = 2 * x * y;
    
   // point(y,z,complex);
    holder[int(pointInc + beginArray)][int(pointInc + beginArray)][0] = y;
    holder[int(pointInc + beginArray)][int(pointInc + beginArray)][1] = z;
    holder[int(pointInc + beginArray)][int(pointInc + beginArray)][2] = complex;    
  }
  }
  
  beginShape();
  for(int drawIt = 0; drawIt < holder.length; drawIt ++){
    vertex(holder[drawIt][drawIt][0], holder[drawIt][drawIt][1], holder[drawIt][drawIt][2]);
  }
  endShape();
    
  
  println("holder " + holder[40][2]);
  
  println("x: " + x);
  println("y: " + y);
  println("z: " + z);
  println("complex: " + complex);
  //endShape();
    
  





  time += timeScale;


  camera( mouseX-( width/2 ),mouseY-( height/2 ), 220.0, // eyeX, eyeY, eyeZ
  0.0, 0.0, 0.0, // centerX, centerY, centerZ
  0.0, 1.0, 0.0 ); // upX, upY, upZ
};

