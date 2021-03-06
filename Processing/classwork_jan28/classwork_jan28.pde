/*
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



void setup(){
  size( 600, 600 ); 
  background( 170, 203, 237 );
  stroke( 168, 4, 13 );
  strokeWeight( 3 );
  noFill();
  smooth();  
}


void draw(){
  background( 170, 203, 237 );
  if ( mousePressed ){     
     //when the mouse distance is far enough away from the previous location, add another point to the array    
     if( sqrt( sq( mouseX - x_points[ idx ] ) + sq( mouseY - y_points[ idx ] ) ) > 20 ){
        idx ++;  
        x_points[ idx ] = mouseX;
        y_points[ idx ] = mouseY;        
     }   
   }
   //if mouse becomes unpressed start the idx count over for a new line --if the background is refreshed per draw, each line is shown until mouse released--
   else{
     idx = 0;
   }
  beginShape();
  for( int i = 1; i < idx; i++ ){  //begins at 1 to avoid a weird squiggle from x_points and y_points starting out empty while mouseX, mouseY are still to close 
    curveVertex( x_points[ i ], y_points[ i ] );      
  }
  curveVertex( mouseX, mouseY );
  endShape();
}

