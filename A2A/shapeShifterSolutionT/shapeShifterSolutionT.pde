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
float slopeValue = 1;
float slope;
//float slopeChange;
float interXeptValue = -88;
float interXept;
float interXeptChange;
int morphL = 100;
int stop = 0;

float[][][][] holder = new float[morphL][holderLength][holderLength][3];


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

  if(stop < morphL) {

    for(int Morph = 0; Morph < morphL; Morph ++ ) {
      //slope and intercept reassignments
      slope = slopeValue / 1;
      interXept = interXeptValue;

      x = time;//the x term(axis)of the function is used as "time" as the complex term is not constrainable

        if( x < end) {


        for(float pointInc = begin; pointInc < end; pointInc += 1 ) {

          y = pointInc;

          z = (x*x) - (y*y);

          //complex = ((176-iterate)/176)*(y+45);//-(88-iterate);
          //complex = y * (176-iterate)/176;
          //complex = ((176-iterate)/176)*(y-40);
          //complex = ( ((176-iterate)/176)*(y-148)+(88-iterate) )+88;
          //complex = 2*x*y;
          complex = slope * y + interXept;
          //array to load set of parabolas into; xCount is for a single parabola
          holder[Morph][xCount][int(pointInc + beginArray)][0] = complex*.01;//scaled for display
          holder[Morph][xCount][int(pointInc + beginArray)][1] = y*1;
          holder[Morph][xCount][int(pointInc + beginArray)][2] = z*.01;
        }
      }

      xCount ++;//increments array for each parabola per "frame" of "time"
      interXeptValue += 1;
      slopeValue += 1;
      time += timeScale;//advances one frame of time



        //slope and intercept advances
      interXeptValue += 1;
      slopeValue += 1;
    }
    stop ++;
  }

  

  displaySurf();

  camera( mouseX-( width/2 ),mouseY-( height/2 ), 220.0, // eyeX, eyeY, eyeZ
  0.0, 0.0, 0.0, // centerX, centerY, centerZ
  0.0, 1.0, 0.0 ); // upX, upY, upZ
};




void displaySurf() {
  //displays the complete set of parabolas showing complex surface
  for(int morph =0; morph < morphL; morph++) {
    for(int idx=0; idx< holderLength; idx ++) {
      beginShape();
      for(int drawIt = 0; drawIt < holderLength; drawIt ++) {
        vertex(holder[morph][idx][drawIt][0], holder[morph][idx][drawIt][1], holder[morph][idx][drawIt][2]);
      }
      endShape();
    }
  }
}

//void fillArray() {
//
//  for(float pointInc = begin; pointInc < end; pointInc += 1 ) {
//    y = pointInc;
//
//    z = (x*x) - (y*y);
//
//    //complex = ((176-iterate)/176)*(y+45);//-(88-iterate);
//    //complex = y * (176-iterate)/176;
//    //complex = ((176-iterate)/176)*(y-40);
//    //complex = ( ((176-iterate)/176)*(y-148)+(88-iterate) )+88;
//    //complex = 2*x*y;
//    complex = slope * y + interXept;
//    //array to load set of parabolas into; xCount is for a single parabola
//    holder[Morph][xCount][int(pointInc + beginArray)][0] = complex*.01;//scaled for display
//    holder[Morph][xCount][int(pointInc + beginArray)][1] = y*1;
//    holder[Morph][xCount][int(pointInc + beginArray)][2] = z*.01;
//  }
//}

