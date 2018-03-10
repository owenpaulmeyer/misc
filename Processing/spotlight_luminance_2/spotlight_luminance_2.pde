//spotlight luminance takes a provided image
//the image is tinted a little bit
//as the user mouses over the image a spotlight showing the negative values of the image is displayed, with a gradient ring around the spotlight.


PImage photo;  //types a variable "photo" of the class PImage

void setup() {
  photo = loadImage( "forblender.jpg" );  //loads the image "test" into the variable "photo"
  size(photo.width,photo.height);  //sets the screen dimmensions to that of the image
}

float inverse_effect( float factor, float color_bit ) {
     
//  return (255-color_bit);  //inverts the color value
  
    return (1-factor)*(255/2) + (255-color_bit)*factor;  //a different effect option
   
  //return (1-factor)*(255-color_bit)  //yet another effect option
  // +
  // factor*(255/2) ;
    
 
}


void draw() {
  loadPixels();  //calls up the pixels array
  for (int x = 0; x < photo.width; x++ ) {  //nested loop; cycles through all of the xy coordinates of the image
    for (int y = 0; y < photo.height; y++ ) {
     
      int loc = x + y*photo.width;  //translates the x,y coordinate into the linear pixels array's coresponding location
     
      float r = red (photo.pixels[loc]);  //gets the rgb values from the pixels array and loads them into variables of coresponding rgb names
      float g = green (photo.pixels[loc]);
      float b = blue (photo.pixels[loc]);
     
      r *= .8;  //tints the rgb values with multipliers
      b *= .4;
      g *= .9;
   
      float x_dist = sq(mouseX - x);  //same as using the dist() function, just uses pythagorean instead
      float y_dist = sq(mouseY - y);
      float distance = sqrt(x_dist + y_dist);
     
      float spot_radius = 100;  //sets the radius of the negative spotlight

      if (distance < spot_radius){  //locations inside the spotlight area
        
        float dist_factor = 1-distance/spot_radius;  //dist_factor is the relative distance from the spotlight margin (0 to 1)

        r = inverse_effect( dist_factor, r );  //this is taking the existing rgb values and subtracting them from 255 (as difined above)to create the negative area
        g = inverse_effect( dist_factor, g );  //the dist_factor is supperflous with the current effect option
        b = inverse_effect( dist_factor, b );
      }
      else if (distance < spot_radius*20){  //this is for the area from the spotlight rim to double the spot radius
        
        float dist_factor =  distance/spot_radius-1;  //returns a gradient from 0 (at the spotlight rim) to 1 (at double the spot radius)
        
        if (brightness(photo.pixels[loc]) < 100){
          r *= dist_factor;  //applies said gradient to the existing rgb values
          g *= dist_factor;
          b *= dist_factor;
        }
        else if (brightness(photo.pixels[loc]) >= 100){
          r *= dist_factor*1.5;  //applies said gradient to the existing rgb values
          g *= dist_factor*1.5;
          b *= dist_factor*1.5;
        }
      }
     
      color c = color(r,g,b);  //assigns the new rgb values to a variable "c" of the class color
      pixels[loc] = c;  //loads the new rgb values for the current x,y location from the variable "c" into the corresponding location in the pixels array
    }
  }
 
  updatePixels();  //establishes the completion of the pixel operations and now we are ready to view (the draw function will now "draw" our modified image
}

