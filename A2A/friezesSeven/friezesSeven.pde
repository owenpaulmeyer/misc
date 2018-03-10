//Owen Meyer
//Seven Frieze Patterns

void setup() {
  size( 580, 980 );
  strokeJoin(MITER);
  strokeCap(PROJECT);
  noFill();
  strokeWeight( 2 );

  int stagger = 18;
  
//first
  translate( 40, 40 );
  stroke( 200, 0, 0 );
  //line( -40, stagger, (900-40), stagger );
  stroke( 0 );
  for(int idx=0; idx<10; idx++) {
    pushMatrix();
    translate( 52*idx, 0 );
    squarePlex();
    popMatrix();    
  }
//second
  translate( 0, 120 );
  stroke( 200, 0, 0 );
  //line( -40, 0, (900-40), 0 );
  stroke( 0 );
  for(int idx=0; idx<14; idx++) {
    pushMatrix();
    stagger *= -1;
    translate( 36*idx, stagger );
    squarePlex();
    popMatrix();
  }
//third
  translate( 0, 120 );
  stroke( 200, 0, 0 );
  //line( -40, stagger, (900-40), stagger );
  stroke( 0 );
  for(int idx=0; idx<5; idx++) {    
    pushMatrix();    
    translate( 112*idx, 0 );
    squarePlex();
    translate( 43, 0 );
    scale(-1,1);
    squarePlex();
    popMatrix();
  }
//fourth
  translate( 0, 120 );
  stroke( 200, 0, 0 );
  //line( -40, -9, (900-40), -9 );
  stroke( 0 );
  for(int idx=0; idx<5; idx++) {    
    pushMatrix();
    if( (idx%2)+1 == 1 ) {
      scale( 1,-1 );
      translate( 0, stagger );
    }
    translate( 110*idx, 0 );
    squarePlex();
    translate( 54, 0 );
    scale(-1,1);
    squarePlex();
    popMatrix();
  }
//fifth
  translate( 0, 108 );
  stroke( 200, 0, 0 );
  //line( -40, stagger*2-2, (900-40), stagger*2-2 );
  stroke( 0 );
  for(int idx=0; idx<9; idx++) {    
    pushMatrix();    
    translate( 55*idx, 0 );
    squarePlex();
    translate( 0, 66 );
    scale(1,-1);
    squarePlex();
    popMatrix();
  }
  //sixth
  translate( 0, 170 );
  stroke( 200, 0, 0 );
  //line( -40, stagger*2-2, (900-40), stagger*2-2 );
  stroke( 0 );
  for(int idx=0; idx<9; idx++) {    
    pushMatrix();    
    translate( 55*idx, 0 );
    squarePlex();
    translate( 0, 66 );
    scale(1,-1);
    translate( 40, 0 );
    squarePlex();
    popMatrix();
  }
  //seventh
  translate( 0, 170 );
  stroke( 200, 0, 0 );
  //line( -40, stagger*2-2, (900-40), stagger*2-2 );
  stroke( 0 );
  for(int idx=0; idx<9; idx++) {    
    pushMatrix();    
    translate( 55*idx, 0 );
    if( (idx%2)+1 == 1 ) {
      scale( -1, 1 );
    }
    squarePlex();
    translate( 0, 66 );
    scale(1,-1);
    squarePlex();
    popMatrix();
  }
  
  
};


//Pattern to be Frozen
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

