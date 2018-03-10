float xPoint, yPoint;
int lines = 1;
float rotes = 1;
void setup() {
  size( 825, 825 );
  //rectMode( CENTER );
  noFill();
  smooth();
  scale(1.5,1.5);
  
  strokeWeight( 8 );

}

void draw(){
  delay(60);
  fill( 100, 40 );
  rect(0,0,width,height);
  noFill();
  scale(1.5,1.5);
  rotes = 1;
  
translate( 48, 48 );


  for( int idx = 0; idx < 5; idx++ ) {
    pushMatrix();
    translate( 110*idx, 0 );


    for( int idxD = 0; idxD < 5; idxD++ ) {
      pushMatrix();
      translate( 0, 110*idxD );
      stroke( 0 );
      strokeWeight( 8 );
      rotate( radians(22.5 * rotes + (mouseX/2)) );

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
    xPoint = ( cos( radians( 135*idx ) ) ) * 53;
    yPoint = ( sin( radians( 135*idx ) ) ) * 53;
    vertex( xPoint, yPoint );
  }
  endShape(CLOSE);
}
//rect( 0, 0, 57, 57 );

