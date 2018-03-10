// Learning Processing
// Daniel Shiffman
// http://www.learningprocessing.com

// Example 15-9: Adjusting image brightness based on pixel location (Flashlight effect)

PImage loaded_image;

void setup() {
  size(1024,768);
  loaded_image = loadImage( "design.jpg" );
}

float inverse_amount( float factor, float color_bit ) {
  // factor is the amount to inverse this bit of color (0 to 1)
  // color_bit is one rgb of color (0 to 255)
  
  return factor>0 ? (255-color_bit)*factor : color_bit;
//  return 
//    (1 - factor)*color_bit        // this value will be the color, when the factor is small,
//                                  // but close to zero, when the factor is large (close to one)
//      + 
//    (factor)*(255 - color_bit);   // this value will be close to zero, when the factor is small
//                                  // but close to the inverse color, when the factor is large (close to one)
} 

void draw() {
  loadPixels();
 
  // We must also call loadPixels() on the PImage since we are going to read its pixels.  loaded_image.loadPixels();
  for (int x = 0; x < loaded_image.width; x++ ) {
    for (int y = 0; y < loaded_image.height; y++ ) {
     
      // Calculate the 1D pixel location
      int loc = x + y*loaded_image.width;
     
      // Get the R,G,B values from image
      float r = red (loaded_image.pixels[loc]);
      float g = green (loaded_image.pixels[loc]);
      float b = blue (loaded_image.pixels[loc]);
     
      // Calculate an amount to change brightness
      // based on proximity to the mouse
      float x_dist = sq(mouseX - x);
      float y_dist = sq(mouseY - y);
      float distance = sqrt(x_dist + y_dist);
     
      float spot_radius = 150;

      if (distance < spot_radius){  // within the spotlight
      
        // d_factor is the relative distance from the spotlight margin (0 to 1)
        float d_factor = (spot_radius - distance) / spot_radius; //This is 1-distance/spot_radius
        
        r = inverse_amount( d_factor, r );
        g = inverse_amount( d_factor, g );
        b = inverse_amount( d_factor, b );
      }

     
      // Constrain RGB to between 0-255
      r = constrain(r,0,255);
      g = constrain(g,0,255);
      b = constrain(b,0,255);
     
      // Make a new color and set pixel in the window
      color c = color(r,g,b);
      pixels[loc] = c;
    }
  }
 
  updatePixels();
}

