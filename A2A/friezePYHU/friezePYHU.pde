void setup() {
  size( 500, 500 );

  //strokeWeight( 2 );
  strokeJoin(MITER);
  strokeCap(PROJECT);

 scale( 2, 2 );
  noFill();

  translate( width/4, height/4 );
  squarePlex();

  //rectMode(CENTER);
  //rect(0,0,.2,.2);
}

void squarePlex() {
  strokeWeight( 5 );

  for( int layer=0; layer<2; layer++ ) {
    if( layer == 1 ) {
      strokeWeight( 1 );
      stroke( 255 );
    }

    for( int idx=0; idx < 4; idx++ ) {
      beginShape();
      vertex( -31, -9 );
      vertex( -31, 15 );
      vertex( 3, 15 );
      endShape();
      rotate(PI/2);
    }
    for( int idx=0; idx < 4; idx++ ) {
      beginShape();
      vertex( 3, 15 );
      vertex( 3, -9 );
      vertex( -31, -9 );
      endShape();
      rotate(PI/2);
    }
  }
}

