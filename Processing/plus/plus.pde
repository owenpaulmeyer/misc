void setup(){
  size (400,400);
  background(60,117,175);
 
}



void draw(){
  strokeWeight(3);
  stroke(0);
  fill(0);
  drawPlus();
  translate(10,10);
  stroke(157,2,20);
  fill(100);
  drawPlus();
  
}
  
void drawPlus (){//plus shaped figure
  beginShape();
  vertex(60,20);
  vertex(100,20);
  vertex(100,60);
  vertex(140,60);
  vertex(140,100);
  vertex(100,100);
  vertex(100,140);
  vertex(60,140);
  vertex(60,100);
  vertex(20,100);
  vertex(20,60);
  vertex(60,60);
  endShape(CLOSE);
  
}
