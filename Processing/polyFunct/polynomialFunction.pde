float [] coefPass = { 0,-150,0,300,0,-85,0,0,0,1 };  //the first
float xBegin = -5;
float xEnd = 5;
float xSpan = xEnd - xBegin;
float X = xBegin;
float xInc = .05;
float xFeed = xBegin;
int Y;
float[][] xNy = new float[ int(xSpan/xInc) ][ 2 ];
float xScale = 40;
float yScale = .1;


void setup(){
  smooth();
  size( 400, 400 );
  translate( width/2, height/2 );
  scale( 1, -1 );
  noFill();
  stroke( 0, 0, 255 );
  line( -width/2, 0, width/2, 0);
  stroke( 0, 255, 0 );
  line( 0, -height/2, 0, height/2 );
  stroke( 0 );

  println( "iteration #  " + int(xSpan/xInc) );

  fillxNy();
  displayxNy();

}

float polyFunct( float[] coef, float ex){
  float carrier = 0;

  for( int idx = 0; idx < coef.length; idx++ ){
    carrier += coef[ idx ] * pow( ex, idx );
  }
  return carrier;
}

void fillxNy(){
for( int itr = 0; itr < int(xSpan/xInc); itr++ ){
    xNy[ itr ][ 0 ] = xFeed;
    xNy[ itr ][ 1 ] = polyFunct(coefPass, xFeed );

    xFeed += xInc;  
  }
}

void displayxNy(){
  beginShape();
  for( int coord = 0; coord < int(xSpan/xInc); coord++ ){
    vertex( xNy[ coord ][ 0 ] * xScale,  xNy[ coord ][ 1 ] * yScale );
  }
  endShape();
  
}
  
