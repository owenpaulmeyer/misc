float xPoint, yPoint;

void setup() {
  size( 550, 550 );
  rectMode( CENTER );
  noFill();
  smooth();
  translate( 48, 48 );
  strokeWeight( 8 );

  int lines = 1;
    float rotes = 1;




    for( int idx = 0; idx < 7; idx++ ) {
      pushMatrix();
      translate( 76*idx, 0 );
      

      for( int idxD = 0; idxD < 7; idxD++ ) {
        pushMatrix();
        translate( 0, 76*idxD );
        stroke( 0 );
        strokeWeight( 8 );
           rotate( radians(22.5 * rotes) );
        
          for( int two = 0; two < 4; two ++) {
        drawStar();
        
            stroke( 255 );
    strokeWeight( 4 );
    lines ++;
    if( two == 2 ) {
      stroke( 0 );
      strokeWeight( 1 );
    }
    println( two );
  }
        popMatrix();
        rotes++;
      }
      //println( idx );
      popMatrix();
    }


};

void drawStar() {
  beginShape();
  for( int idx = 0; idx < 8; idx ++ ) {
    xPoint = ( cos( radians( 135*idx ) ) ) * 40;
    yPoint = ( sin( radians( 135*idx ) ) ) * 40;
    vertex( xPoint, yPoint );
  }
  endShape(CLOSE);
}
//rect( 0, 0, 57, 57 );

