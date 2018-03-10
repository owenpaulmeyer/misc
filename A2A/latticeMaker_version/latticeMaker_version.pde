//Owen Meyer
//LatticeMaker
//




void setup() {
  size( 770,770 );
  scale(1.5,1.5);
  background( 53, 167, 198 );
  rectMode( CENTER );
  noFill();
  smooth();
  translate( 28, 28 );
  strokeWeight( 2 );
  stroke(0);
  int lines = 1;
  float rotes = 1;

  //noStroke();
  //strokeWeight( 4 );


  //pink squaqers; two sets
  for( float sqrsX = 1; sqrsX < 5; sqrsX ++ ) {
    for( float sqrsY = 1; sqrsY < 4; sqrsY ++ ) {
      
      pushMatrix();
      translate( 152.4 * sqrsX-153, 152.4 * sqrsY-77 );
      rotate( radians(45) );
      
      //stroke(255);
      fill( 148 );
      pushMatrix();
      rotate( radians( 45) );
      strokeWeight(2);
     // rect( 0, 0, 73, 73 );
      popMatrix();
      stroke( 0 );
fill( 252, 170, 87 );//orange back squares
      rect( 0, 0, 72, 72);
     
      fill( 140, 232, 178 );//purple centers
      rect( 0, 0, 24, 24 );
      println( "x:"+sqrsX );
      println( "y:"+sqrsY );
      popMatrix();
    }
  }
  for( float sqrsX = 0; sqrsX < 5; sqrsX ++ ) {
    for( float sqrsY = 1; sqrsY < 5; sqrsY ++ ) {
      pushMatrix();
      translate( 152.4 * sqrsX-77, 152.3 * sqrsY-153 );
      rotate( radians(45) );
      strokeWeight(2);
           fill( 59, 89, 194 );
      rect( 0, 0, 108, 108 );
      
      fill( 53, 167, 198 );//pink back squares
      rect( 0, 0, 71, 71 );
       fill( 106, 114, 201 );//blue centers
      
      rect( 0, 0, 24, 24 );
      println( "x:"+sqrsX );
      println( "y:"+sqrsY );
      popMatrix();
    }
  }


filter(BLUR, 1.5);

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
        stroke( 0 );
        
      }

      for( int two = 0; two < 4; two ++) {//draws the lines on lines for the stars
        drawStar();

        stroke( 255, 238, 167, 200 );// star color
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
    xPoint = ( cos( radians( 135*idx ) ) ) * 38;
    yPoint = ( sin( radians( 135*idx ) ) ) * 38;
    vertex( xPoint, yPoint );
  }
  endShape(CLOSE);
}
//rect( 0, 0, 57, 57 );

