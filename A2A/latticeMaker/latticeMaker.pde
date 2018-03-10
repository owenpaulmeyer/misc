//Owen Meyer
//LatticeMaker
//




void setup() {
  size( 825, 825 );
  scale(1.5,1.5);
  background( 140, 227, 222 );
  rectMode( CENTER );
  noFill();
  smooth();
  translate( 48, 48 );
  strokeWeight( 2 );
  stroke(10);
  int lines = 1;
  float rotes = 1;

  //noStroke();
  //strokeWeight( 4 );


  //pink squaqers; two sets
  for( float sqrsX = 1; sqrsX < 5; sqrsX ++ ) {
    for( float sqrsY = 1; sqrsY < 4; sqrsY ++ ) {
      fill( 45, 75, 194 );//blue back squares
      pushMatrix();
      translate( 152.4 * sqrsX-153, 152.4 * sqrsY-77 );
      rotate( radians(45) );

      rect( 0, 0, 74, 74 );
     
      fill( 105, 15, 124 );//purple centers
      rect( 0, 0, 24, 24 );
      println( "x:"+sqrsX );
      println( "y:"+sqrsY );
      popMatrix();
    }
  }
  for( float sqrsX = 1; sqrsX < 4; sqrsX ++ ) {
    for( float sqrsY = 1; sqrsY < 5; sqrsY ++ ) {
      pushMatrix();
      translate( 152.4 * sqrsX-77, 152.4 * sqrsY-153 );
      rotate( radians(45) );
      fill( 222, 163, 184 );//pink back squares
      rect( 0, 0, 74, 74 );
       fill( 106, 114, 201 );//blue centers
      
      rect( 0, 0, 24, 24 );
      println( "x:"+sqrsX );
      println( "y:"+sqrsY );
      popMatrix();
    }
  }




  //draws the stars
  for( int idx = 0; idx < 7; idx++ ) {
    pushMatrix();
    translate( 76*idx, 0 );

    for( int idxD = 0; idxD < 7; idxD++ ) {
      pushMatrix();
      translate( 0, 76*idxD );
      stroke( 0 );
      //fill( 62, 71, 149 );//alternate look, fills unbiased stars with blue
      noFill();//to see through the unbiased stars
      strokeWeight( 10 );
      rotate( radians(22.5 * rotes) );

      if( rotes % 2 -1 == 0 ) {//fills the biased stars green
        fill( 29, 116, 38 );
        pushMatrix();
        rotate( radians(22.5) );
        noStroke();
        rect( 0, 0, 28, 28 );
        noFill();
        popMatrix();
        stroke( 10 );
      }

      for( int two = 0; two < 4; two ++) {//draws the lines on lines for the stars
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
  filter(BLUR, .6);//fixes the aliasing up a bit more beyond smooth();
};

void drawStar() {
  float xPoint, yPoint;
  beginShape();
  for( int idx = 0; idx < 8; idx ++ ) {
    xPoint = ( cos( radians( 135*idx ) ) ) * 40;
    yPoint = ( sin( radians( 135*idx ) ) ) * 40;
    vertex( xPoint, yPoint );
  }
  endShape(CLOSE);
}
//rect( 0, 0, 57, 57 );

