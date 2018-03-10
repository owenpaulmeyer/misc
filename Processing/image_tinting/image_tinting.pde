PImage photo_1;  //types a variable "photo" of the class PImage
PImage photo_2;
//PImage photo_3;
//PImage photo_4;

void setup() {
  photo_1 = loadImage( "image_1.jpg" );  //loads the image "test" into the variable "photo"
  photo_2 = loadImage( "image_2.jpg" ); 
//  photo_3 = loadImage( "image_3.jpg" ); 
//  photo_4 = loadImage( "image_4.jpg" ); 

  size(photo_1.width+photo_2.width,photo_1.height);  //sets the screen dimmensions to that of the image
}




void draw() {

  tint(107,113,247);
  image(photo_1,0,0);
  tint(132,222,221);
  image(photo_2,photo_1.width,0);
//  tint(226,147,242);
//  image(photo_3,0,photo_1.height);
//  tint(180,29,65);
//  image(photo_4,photo_1.width,photo_1.height);
  
}

