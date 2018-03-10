float xPoint, yPoint;

void setup() {
  size( 550, 550 );
  background( 144, 184, 185 );
  rectMode( CENTER );
  noFill();
  smooth();
  translate( 48, 48 );
  // strokeWeight( 8 );

  int lines = 1;
  float rotes = 1;

  //stroke( 255 );
  //strokeWeight( 4 );
  fill( 121, 12, 12 );


  for( float sqrsX = 1; sqrsX < 5; sqrsX ++ ) {
    for( float sqrsY = 1; sqrsY < 4; sqrsY ++ ) {
      pushMatrix();
      translate( 152.9 * sqrsX-153.8, 153.5 * sqrsY-79 );
      rotate( radians(45) );

      rect( 0, 0, 75, 75 );
      println( "x:"+sqrsX );
      println( "y:"+sqrsY );
      popMatrix();
    }
  }

  for( float sqrsX = 1; sqrsX < 4; sqrsX ++ ) {
    for( float sqrsY = 1; sqrsY < 5; sqrsY ++ ) {
      pushMatrix();
      translate( 152.9 * sqrsX-80, 153 * sqrsY-154 );
      rotate( radians(45) );

      rect( 0, 0, 75, 75 );
      println( "x:"+sqrsX );
      println( "y:"+sqrsY );
      popMatrix();
    }
  }

  noFill();

  for( int idx = 0; idx < 7; idx++ ) {
    pushMatrix();
    translate( 76*idx, 0 );


    for( int idxD = 0; idxD < 7; idxD++ ) {
      pushMatrix();
      translate( 0, 76*idxD );
      stroke( 0 );
      fill( 62, 71, 149 );
      strokeWeight( 11 );
      rotate( radians(22.5 * rotes) );
      
      if( rotes % 2 -1 == 0 ){
      fill( 35, 118, 38 );
      }

      for( int two = 0; two < 4; two ++) {
        drawStar();

        stroke( 255, 238, 167 );
        strokeWeight( 6 );
        lines ++;
        if( two == 2 ) {
          noFill();
          stroke( 0 );
          strokeWeight( 2 );
        }
        // println( two );
      }
      popMatrix();
      rotes++;
    }
    //println( idx );
    popMatrix();
  }
  filter(BLUR, .6);
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

