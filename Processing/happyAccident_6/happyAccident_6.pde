//Owen Meyer
//not the cleanest code ever written, but it makes a nice effect

Turtle turtle;
int sideCount = 3;       //number of sides per gon
float Radius = 170;      //intial gon size
int Spin = 8;            //degrees of rotation for spinGon

float spinner = -10;
float inc = .1;

void setup() {

  size( 900,900 );
  strokeWeight( 2 );
  smooth();
  //frameRate( 2);

  turtle = new Turtle();
  //println("dir start:" + turtle.dir/360 );
}


void draw() {


  background( 230 );
  //turtle.right(1);  rotate test

  // functionZ(oneX,oneY);
  // functionZ(twoX,twoY);
  // functionZ(threeX,threeY);
  // functionZ(fourX, fourY);
  // turtle.x = width/2;
  // turtle.y = height/2;
  //spinGon( sideCount,Radius, (mouseX + mouseY)/100);
  functionZ( width/2, height/2,-1,spinner );
  functionZ( width/2, height/2,1,spinner );
  spinner = spinner + inc;
  if(spinner > 10){
    spinner= -10;
  }


}



void functionZ(int xX, int yY, int flip,float spinner) {


  turtle.setxy( xX, yY );
  spinGon( 4, Radius*2, spinner*flip);

  //turtle.pd();
  //turtle.forward( Radius + ( Radius / 2 ) );
  //println("x1:" + turtle.x);
  //println("y1:" + turtle.y);
  //cGon( sideCount, Radius/2 );
  //println("x2:" + turtle.x);
  //println("y2:" + turtle.y);
  //turtle.right( 180. );
  //turtle.forward( Radius + ( Radius / 2 ) );
  //turtle.left( 180. );

  //reset initial state for accumulative error
  turtle.seth( -90 );
  turtle.setxy( xX, yY );
  //println( turtle.dir );

  float turnRatio = 360. / 8;
  float rotater = 360. / 4;

  for( int idx = 0; idx < 8; idx ++ ) {

    turtle.right( turnRatio );  //turn ratio
    turtle.forward( Radius + ( Radius *.71 ) );
    turtle.left( rotater );   //turn ratio * 2 ( this sets the smaller gon to the right rotation for its travel

    spinGon( sideCount, Radius*1.5, spinner*flip);
    //turtle.right( 360. / 4 );  //rotate back turn ratio * 2
    //turtle.right( 180. );
    turtle.seth( -90 );
    turtle.setxy( xX, yY );
    turnRatio = turnRatio + ( 360. / 8 );
    rotater = rotater + 360./4;
    //spinner++;
    
  }
}


void cGon( int sidecount, float radius ) {

  //parameters of a gon
  float angle1 = ( 180. - (360./sidecount) )/2;     //initial rotation angle into gon drawing after coming up from turtle start
  float sideLength = ( sin(radians(( 360. / sidecount )/2))*2 ) * radius;    //calcs polygon side length from 360 deg. and number of poly sides
  float angle2 = 360. / sidecount;       //angle to rotate turtle between side drawing
  float angle3 = ( 180. + (360. / sidecount ) )/2;   //angle to rotate to return to center of gon
  //println( "angle1:" + angle1 );
  //println( "angle2:" + angle2 );
  //println( "angle3:" + angle3 );

  //gets the turtle to the starting point
  turtle.pu();               //pen up
  turtle.forward( radius );  //radius of gon 
  turtle.right( angle1 );    //initial turn before commencing to draw a gon
  turtle.pd();               //pen down

  //Draws the sides of the gon
  for( int idx = 0; idx < sidecount; idx++ ) {

    turtle.right( angle2 );    //rotation between drawing sides
    turtle.forward( sideLength );    //go ahead and actually draw a side
  }

  //Returns turtle to initial state
  //println("dir, before return:"+turtle.dir);
  turtle.right( angle3 );          //angle to rotate to face turtle at starting position
  turtle.pu();                       //pen up
  turtle.forward( radius );           //move turtle back to start
  turtle.right( 180. );                //rotate turtle to starting heading
}

void spinGon( int sidecount, float radius, float spin ) {

  int colorC = 200;
  float angle1 = ( 180.-(360./sidecount) )/2;     //initial rotation angle into gon drawing after coming up from turtle start
  float sideLength = ( sin(radians(( 360./sidecount )/2))*2 )*radius;    //calcs polygon side length from 360 deg. and number of poly sides
  float angle2 = 360./sidecount;       //angle to rotate turtle between side drawing
  float angle3 = ( 180.+(360./sidecount) )/2;   //angle to rotate to return to center of gon
  int spin_num = 50;     //number of consecutive gons to draw
  float scaled = 1;       //to make consecutive gons bigger or smaller
  for(int spinx = 0; spinx < spin_num; spinx++) {
    turtle.c = color(colorC,100);

    turtle.pu();
    turtle.forward( radius * scaled );
    turtle.right( angle1 );
    turtle.pd();

    for( int idx = 0; idx < sidecount; idx++) {

      turtle.right( angle2 );
      turtle.forward( sideLength * scaled );
    }

    turtle.right( angle3 );
    turtle.pu();
    turtle.forward( radius * scaled );
    turtle.right( 180 + spin );   //180 here would be consentric gons without spin
    scaled = scaled * .92;
    colorC -= 5;
    if(colorC < 0){
      colorC = 20;
    }
  }
}




// create a class for turtle geometry
// forward, backward, turnLeft, turnRight
// drawiOn, drawOff
// Richard
// Sept 2010


class Turtle {
  color c;
  float x, y;  //position
  float dir;  //counter clockwise from x-axis
  int drawing;  //draw when the turtle moves

  // constructor
  Turtle() {
    c = color( 43, 131, 42 ); //green
    x = width/2;
    y = height/2;
    dir = -90;
    drawing = 1;  //drawing on
  } 

  // pen up, pen down
  void pu() {
    drawing = 0;
  }

  void pd() {
    drawing = 1;
  }


  // set position
  void setxy (float xpos, float ypos) {
    x = xpos;
    y = ypos;
  }

  // set heading
  void seth (float h) {
    dir = h;
  }

  // move commands
  void forward(float dis) {
    float del_x = dis * cos(radians(dir));
    float del_y = dis * sin(radians(dir));
    if (drawing==1) {
      stroke(c);
      line(x, y, x + del_x, y + del_y);
    }

    // update xpos, ypos
    x += del_x;
    y += del_y;
  }

  void right(float theta) {
    dir += theta;
  }

  void left(float theta) {
    dir -= theta;
  }

  void draw_icon() {
    stroke(0,255,0);  //green
    triangle(x, y, 
    x+10*cos(radians(dir-135)), y+10*sin(radians(dir-135)), 
    x+10*cos(radians(dir+135)), y+10*sin(radians(dir+135)));
    stroke(c);
  }
}


