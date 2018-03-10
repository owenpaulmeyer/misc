
PImage photo;

void setup() {
  photo = loadImage( "scene.jpg" );
  size(photo.width,photo.height);
  
}

float inverse_effect( float factor, float color_bit ) {
  // factor is the amount to inverse this bit of color (0 to 1)
  // color_bit is one rgb of color (0 to 255)
  return (1-factor)*(255/2) + (255-color_bit)*factor;//-----


//return (1-factor)*(255-color_bit)
// +
// factor*(255/2) ;//------
//  return (255-color_bit)*factor;//------
}
//
//float inverse_effect( float factor, float color_bit ) {
//  // factor is the amount to inverse this bit of color (0 to 1)
//  // color_bit is one rgb of color (0 to 255)
//  
//  return 
//    (1 - factor)*color_bit        // this value will be the color, when the factor is small,
//                                  // but close to zero, when the factor is large (close to one)
//      + 
//    (factor)*(255 - color_bit);   // this value will be close to zero, when the factor is small
//                                  // but close to the inverse color, when the factor is large (close to one)
//} 



void draw() {
  loadPixels();
  for (int x = 0; x < photo.width; x++ ) {
    for (int y = 0; y < photo.height; y++ ) {
     
      // Calculate the 1D pixel location
      int loc = x + y*photo.width;
     
      // Get the R,G,B values from image
      float r = red (photo.pixels[loc]);
      float g = green (photo.pixels[loc]);
      float b = blue (photo.pixels[loc]);
     
      // Calculate an amount to change brightness
      // based on proximity to the mouse
      float x_dist = sq(mouseX - x);
      float y_dist = sq(mouseY - y);
      float distance = sqrt(x_dist + y_dist);
     
      float spot_radius = 250;

      if (distance < spot_radius){  // within the spotlight
        // dist_factor is the relative distance from the spotlight margin (0 to 1)
        float dist_factor = 1-distance/spot_radius;

        r = inverse_effect( dist_factor, r );
        g = inverse_effect( dist_factor, g );
        b = inverse_effect( dist_factor, b );
      }
      else if (distance < spot_radius*2){  // outside the spotlight
        // dist_factor is the relative distance from the spotlight margin (0 to 1)
        float dist_factor =  distance/spot_radius-1;
 
        r *= dist_factor;
        g *= dist_factor;
        b *= dist_factor;
      }
     
      // Make a new color and set pixel in the window
      color c = color(r,g,b);
      pixels[loc] = c;
    }
  }
 
  updatePixels();
}

