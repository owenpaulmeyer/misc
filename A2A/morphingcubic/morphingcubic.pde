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
int holderLine = 100;
int xCount = 0;
float slopeValue = 1;
float slope=0;
//float slopeChange;
float interXeptValue = -88;
float interXept;
float interXeptChange;
int morphL = 200;
int stop = 0;
float theta = 1;
float sinwav;
float pointInc=-88;
float anotherCount=0;

float[][][][] holder = new float[morphL][holderLength][holderLength][3];


void setup() {
  size( 1000, 1000, P3D );
  noFill();
  lights(); 
  frameRate(20);
  background( 211, 234, 223 );
  back = get();
  stroke( 0 );
  smooth();
  translate(width/2,height/2);//origen to center
  println("holderLength: "+holderLength);





  for( int Morph = 0; Morph < morphL; Morph ++ ) {  //inputs numerous surfii
    //slope and intercept reassignments

    interXept = 0;
    time = begin;
    theta = -20+anotherCount;
    slope = 0;
    xCount = -240;
   


    for(int count=0; count < holderLength; count++) {  //inputs one surface
      
        x = time;     
        //interXept += 1;
        println("slope "+slope);
        theta += 1;
        sinwav = sin(radians(theta))*10;
        slope = sinwav ;
        pointInc = -88;//resets starting value for y for each line input
        interXept =-100+xCount;
        
      for(int i = 0; i < holderLength; i ++ ) {  //inputs one line   

        //slope = slopeValue ;     

        y = pointInc;
        z = (x*x*x) - (3*x*y*y);
        complex = slope * y + interXept;

        //array to load set of parabolas into; xCount is for a single parabola
        holder[Morph][count][i][0] = complex*.1;//scaled for display
        holder[Morph][count][i][1] = y*1;
        holder[Morph][count][i][2] = z*.0001;
        

        pointInc++;
        }

      time ++;
      xCount+=4;
      
    }

    //slope and intercept advances
    interXeptValue += 1;
    slopeValue += 1;
    interXeptChange +=10;
    
    anotherCount+=3.6;
  }
  xCount=0;
};



void draw() {
  background( back ); 
  strokeWeight( 1 );
  stroke(0,255,0);
  //line(0,-200,0,0,200,0);
  stroke(255,0,0);
  //line(-200,0,0,200,0,0);
  stroke(0,0,255);
  //line(0,0,-200,0,0,200);
  stroke(0);
  strokeWeight( 1 );
  // println("iterate  " + ((176-iterate)/176)); 





  displaySurf();

  xCount++;
  if( xCount == 100 ) xCount=0;
  // println("xCount " + xCount);

  camera( mouseX-( width/2 ),mouseY-( height/2 ), 220.0, // eyeX, eyeY, eyeZ
  0.0, 0.0, 0.0, // centerX, centerY, centerZ
  0.0, 1.0, 0.0 ); // upX, upY, upZ
};




void displaySurf() {
  //displays the complete set of parabolas showing complex surface

  for(int idx=0; idx< holderLength; idx ++) {
    beginShape();
    for(int drawIt = 0; drawIt < holderLength; drawIt ++) {
      vertex(holder[xCount][idx][drawIt][0], holder[xCount][idx][drawIt][1], holder[xCount][idx][drawIt][2]);
    }
    endShape();
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

