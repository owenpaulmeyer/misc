void setup() {
  size( 560, 880 );
  strokeJoin(MITER);
  strokeCap(PROJECT);
  noFill();
  strokeWeight( 2 );

  int stagger = 18;

  translate( 40, 40 );
  stroke( 200, 0, 0 );
  line( -40, stagger, (900-40), stagger );
  stroke( 0 );
  for(int idx=0; idx<10; idx++) {
    pushMatrix();
    translate( 52*idx, 0 );
    squarePlex();
    popMatrix();
    
  }

  translate( 0, 100 );
  stroke( 200, 0, 0 );
  line( -40, 0, (900-40), 0 );
  stroke( 0 );
  for(int idx=0; idx<10; idx++) {
    pushMatrix();
    stagger *= -1;
    translate( 52*idx, stagger );
    squarePlex();
    popMatrix();
  }

  translate( 0, 100 );
  stroke( 200, 0, 0 );
  line( -40, stagger, (900-40), stagger );
  stroke( 0 );
  for(int idx=0; idx<4; idx++) {    
    pushMatrix();    
    translate( 135*idx, 0 );
    squarePlex();
    translate( 66, 0 );
    scale(-1,1);
    squarePlex();
    popMatrix();
  }

  translate( 0, 100 );
  stroke( 200, 0, 0 );
  line( -40, -9, (900-40), -9 );
  stroke( 0 );
  for(int idx=0; idx<4; idx++) {    
    pushMatrix();
    if( (idx%2)+1 == 1 ) {
      scale( 1,-1 );
      translate( 0, stagger );
    }
    translate( 135*idx, 0 );
    squarePlex();
    translate( 66, 0 );
    scale(-1,1);
    squarePlex();
    popMatrix();
  }

  translate( 0, 88 );
  stroke( 200, 0, 0 );
  line( -40, stagger*2-2, (900-40), stagger*2-2 );
  stroke( 0 );
  for(int idx=0; idx<7; idx++) {    
    pushMatrix();    
    translate( 78*idx, 0 );
    squarePlex();
    translate( 0, 66 );
    scale(1,-1);
    squarePlex();
    popMatrix();
  }
  
  translate( 0, 150 );
  stroke( 200, 0, 0 );
  line( -40, stagger*2-2, (900-40), stagger*2-2 );
  stroke( 0 );
  for(int idx=0; idx<7; idx++) {    
    pushMatrix();    
    translate( 78*idx, 0 );
    squarePlex();
    translate( 0, 66 );
    scale(1,-1);
    translate( 40, 0 );
    squarePlex();
    popMatrix();
  }
  
  translate( 0, 150 );
  stroke( 200, 0, 0 );
  line( -40, stagger*2-2, (900-40), stagger*2-2 );
  stroke( 0 );
  for(int idx=0; idx<7; idx++) {    
    pushMatrix();    
    translate( 78*idx, 0 );
    squarePlex();
    translate( 0, 66 );
    scale(1,-1);
    squarePlex();
    popMatrix();
  }
  
  
};







void squarePlex() {
  strokeWeight( 5 );
  stroke( 0 );

  for( int layer=1; layer<3; layer++ ) {
    if( layer == 2 ) {
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
  strokeWeight( 2 );
}

