/*
further modified to produce a layered accumulation 
  modified to draw a smoothed continuous line from:
    --Richard 
    --Smoothing curves drawn with the mouse
    --based on paint program
*/


float[] x_points = new float[ 1000 ];
float[] y_points = new float[ 1000 ];
int idx;
float x_initial;
float y_initial;
PImage back;
PImage source;
PGraphics overlay;
 int R = 110;
  int G = 88;
  int B = 77;

void setup() {
  size( 1000, 1000 ); 
  background( 170, 203, 237 );
  back = get();
  stroke( 168, 4, 13 );
  strokeWeight( 8 );
//  noFill();
  smooth();
  overlay = createGraphics( 1000, 1000, P2D );
  source = back;
 
}


void draw() {
  background( back );
  if ( mousePressed ) {     
    //when the mouse distance is far enough away from the previous location, add another point to the array    
    if( sqrt( sq( mouseX - x_points[ idx ] ) + sq( mouseY - y_points[ idx ] ) ) > 20 ) {
      idx ++;  
      x_points[ idx ] = mouseX;
      y_points[ idx ] = mouseY;
    }
  }
  //if mouse becomes unpressed start the idx count over for a new line --if the background is refreshed per draw, each line is shown until mouse released--
  else {
    R = ( R + 18 ) % 255;
    G = ( G + 16 ) % 255;
    B = ( B + 23 ) % 255;
    //  image( source, 0, 0 );

    blend( overlay, 0, 0, 1000, 1000, 0, 0, 1000, 1000, DIFFERENCE );
    back = get();
    idx = 0;
  }
  overlay.beginDraw();
  overlay.smooth();
  overlay.background( 0, 0, 0, 1 );
  overlay.noFill();
  overlay.strokeWeight( 8 );
  overlay.stroke( R, G, B );
  overlay.beginShape();
  for( int i = 1; i < idx + 1; i++ ) {  //begins at 1 to avoid a weird squiggle from x_points and y_points starting out empty while mouseX, mouseY are still to close 
    overlay.curveVertex( x_points[ i ], y_points[ i ] );
  }     
  overlay.curveVertex( mouseX, mouseY );
  overlay.endShape();
  overlay.endDraw();

 
  blend( overlay, 0, 0, 1000, 1000, 0, 0, 1000, 1000, DIFFERENCE );
  source = get();
 
}





 //  beginShape();
  //     for( int i = 1; i < idx + 1; i++ ){  //begins at 1 to avoid a weird squiggle from x_points and y_points starting out empty while mouseX, mouseY are still to close 
  //     curveVertex( x_points[ i ], y_points[ i ] );
  //   }
  //  curveVertex( mouseX, mouseY );
  //  endShape();  

