// Declaring a variable of type PImage
PImage img;
PImage img2;	

void setup() {
  size(800,646);
  // Make a new instance of a PImage by loading an image file
  img = loadImage("cube.jpg");
  img2 = loadImage("me.png");
  
}

void draw() {
  tint(255,95);
  image(img2,0,0,800,646);
  //background(img2);
  // Draw the image to the screen at coordinate (0,0)
  image(img,0,0,800,646);
}

