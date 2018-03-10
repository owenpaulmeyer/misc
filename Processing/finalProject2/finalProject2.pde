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
int begin = -110;           //start of plotting range
int beginArray = begin*-1;
//end of plotting range
float pointScale = .1;
float timeScale = 5;

int xCount = 0;
float theta=0;
int strobe=1;
int strobeStart=1;
int phase = 4;
int vale = 19;

float[][][] holderA = new float[vale][121][4];
float[][][] holderB = new float[vale][121][4];
float[][][] holderS = new float[vale][121][4];


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
  populate(holderA);
  time = begin;
  xCount = 0;
  populate(holderB);
  slitScan(holderA);
  // rotationB( -.8,3,0);
};



void draw() {

  background( 80,24,24 ); 
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




  if(frameCount % 11 == 90){
    strobe++;
    strobeStart++;
    if(strobe == phase)strobe=0;
  }



rotation( -.01,2,3,holderS);
   rotation( -.01,0,3,holderS);
  // rotation(-.008,2,0,holderB);
  //rotation(.008,3,0,holderB);
  display(holderS);
  // display(holderB);


  camera( mouseX-( width/2 ),mouseY-( height/2 ), 220.0, // eyeX, eyeY, eyeZ
  0.0, 0.0, 0.0, // centerX, centerY, centerZ
  0.0, 1.0, 0.0 ); // upX, upY, upZ
};


void display(float[][][] holder) {
  //int sloop;

  for(int idx=0; idx< vale-1; idx +=3) {

    for(int drawIt = 0; drawIt < 119; drawIt ++) {//points of a circle
      fill(0+idx*14);

      if( (drawIt + strobe) % phase == 0 ) {
       // noFill();
      }
      //      if( (drawIt + strobeStart) % 120 == 0 ) {
      //        fill(0,0,255);
      //      }

      beginShape();

      vertex(holder[idx][drawIt][0], holder[idx][drawIt][1], holder[idx][drawIt][2]);
      vertex(holder[idx][drawIt+1][0], holder[idx][drawIt+1][1], holder[idx][drawIt+1][2]);
      vertex(holder[idx+1][drawIt+1][0], holder[idx+1][drawIt+1][1], holder[idx+1][drawIt+1][2]);
      vertex(holder[idx+1][drawIt][0], holder[idx+1][drawIt][1], holder[idx+1][drawIt][2]);


      endShape(CLOSE);
    }
  }
}







void populate(float[][][] holder) {
  //the x term(axis)of the function is used as "time" as the complex term is not constrainable

  for(int circles=0; circles < vale; circles++) {
    rad = time;
    //if( rad < end) {  //loads the array until the limit is reached
    for(int angle = 0;angle < 361; angle += 1) {
      x = cos( angle*PI/180 ) *rad;
      y = sin( angle*PI/180 ) *rad;



      z = (x*x) - (y*y);
      // z = x*x*x - 3*x*y*y;

      complex = 2 * x * y; //complex term of the function sans i; just used as the third axis
      // complex = -y*y*y + 3*x*x*y;

      //array to load set of parabolas into; xCount is for a single parabola
      holder[xCount][(angle/3)][0] = x*1;//scaled for display
      holder[xCount][(angle/3)][1] = y*1;
      holder[xCount][(angle/3)][2] = z*.01;//x here in place of the complex term will give the "saddle shape"
      holder[xCount][(angle/3)][3] = complex*.01;



      //displays the complete set of parabolas showing complex surface
    }
    xCount ++;//increments array for each parabola per "frame" of "time"

    time += timeScale;
  }
}




void rotation(float theta, int axisA, int axisB,float[][][] holder) {
  for(int surface=0; surface < vale; surface++) {
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


void slitScan(float[][][] holder) {
 int countey = 0;

  for(int phase=0; phase < 121; phase +=1) {

    

//      if( (drawIt + strobe) % phase == 0 ) {
//        fill(0+idx*14);
//      }
      

      for(int valences = 0; valences < 19; valences++) {//one slit
        
        holderS[valences][phase][0] = holder[valences][phase][0];
        holderS[valences][phase][1] = holder[valences][phase][1];
        holderS[valences][phase][2] = holder[valences][phase][2];
        holderS[valences][phase][3] = holder[valences][phase][3];
        
        
        
      }
      
      rotation(.1049,2,3,holderA);
     
      
//    countey ++;
//    if(countey > 120)countey = 0;
//    println(countey);
  }
}


