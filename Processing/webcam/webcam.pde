/*
Richard
Oct 2010
This allows you to interface Processing with the camera
 and take pictures
 */

import JMyron.*;

JMyron m;//a camera object


void setup(){
  size(320*2,240*2);
  m = new JMyron();//make a new instance of the object
  m.start(width,height);//start a capture at 320x240

}

void draw(){
  m.update();//update the camera view
  int[] img = m.image(); //get the image from the camera
  loadPixels();  
  // copy the image to the Window
  for (int i = 0; i < pixels.length; i++) {
    pixels[i] = img[i];  
  }
  updatePixels(); 
}

// take a snapshot when you click on the image
void mouseClicked(){
  saveFrame("output-###.jpg");  // you can change the name 
}

public void stop(){
  m.stop();//stop the object
  super.stop();
}


