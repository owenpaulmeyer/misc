float xPoint, yPoint;

void setup() {
  size( 540, 540 );
  //background( 150, 22, 22 );
  rectMode( CENTER );
  noFill();
  smooth();
  translate( 48, 0 );
  strokeWeight( 8 );
  //stroke( 0, 0, 240 );
  int lines = 1;
  float rotes = 1;

  //  for( int two = 0; two < 4; two ++) {


  for( int idx = 0; idx < 8; idx++ ) {
    pushMatrix();
    translate( 70*idx, 0 );


    for( int two = 0; two < 4; two ++) {
      for( int idxD = 1; idxD < 8; idxD++ ) {
        pushMatrix();
        translate( 0, 70*idxD );

        rotate( radians(22.5 * rotes) );
        drawStar();   
        popMatrix();
        rotes ++;
      }
      if( two == 2 ) {
        stroke( 0 );
        strokeWeight( 1 );
        println( two );
      }
      
      //println( idx );
      }
      popMatrix();
    

    stroke( 255 );
    strokeWeight( 4 );
    lines ++;
    // if( two == 2 ) {
    // stroke( 0 );
    // strokeWeight( 1 );
     }
    // println( two );
    // }
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

