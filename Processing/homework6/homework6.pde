import processing.pdf.*;

float x,y;


void setup(){
  noFill();
  size( 800,800 );
  translate(width/2,height/2);
  x = -3;
  strokeWeight(2);
  stroke(0);
  beginRecord(PDF, "homework week6.pdf");
  beginShape();
for(float idx = 0; idx<600; idx ++){
  y = (x*x*x*x*x*x*x*x*x) - (85*x*x*x*x*x) + (300*x*x*x) - (150*x);
  
  x= x + .01;
  
  println("x: " + x + "  y: " + y );
  vertex(x*100,y/4);
  
}
endShape();
endRecord();
}


