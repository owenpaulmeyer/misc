/*Created by Brandon Ludahl
 *Processing Lab 3
 *Professor Naima Lowe
 *Art, New Media, and the Science of Perception
 *October 19th, 2010
 *Creates 4 images that shows: the normal image, a very desaturated 
 *to very saturated image, an image showing tints in the full range
 *of hues with the original saturation, and very dim to very bright
 *image.  Each HSB trait cycles back.
*/

int diff;
float delta;
PImage saturations, hues, luminances, original;

void setup(){
  size(400,400);
  colorMode(HSB,200,200,200); //limit and scale the values to 200

  original = loadImage("Ludahl_Lab_3.jpg");
  diff = 0;
  delta = -1.0;
  saturations = createImage(200,200,RGB);
  hues = createImage(200,200,RGB);
  luminances = createImage(200,200,RGB);
}

void draw(){
  original.loadPixels();
  saturations.loadPixels();
  hues.loadPixels();
  luminances.loadPixels();

  //Copy the image to four different PImage objects
  for (int i = 0; i < (200*200); i++)
  {
    float h = hue(original.pixels[i]);
    float s = saturation(original.pixels[i]);
    float l = brightness(original.pixels[i]);

    //%%The effect is such that the values start closer to 0,
    //%%and end closer to 200, and then repeat.
    //Changes the hue, saturation, and luminance by a certain
    //percentage of the difference between the original value
    //and the values of diff, both of which range from 0 to 200.
    saturations.pixels[i] = color(h,s+abs(diff - s)*delta,l);
    hues.pixels[i] = color(h+abs(diff - h)*delta,s,l);
    luminances.pixels[i] = color(h,s,l+abs(diff - s)*delta);
  }
  
  //Assure that the array is updated for usage
  original.updatePixels();
  saturations.updatePixels();
  hues.updatePixels();
  luminances.updatePixels();
  
  //Paint the images to the screen
  image(original,0,1); //upper left
  image(saturations,width/2,1); //upper right
  image(hues,0,height/2); //lower left
  image(luminances,width/2,height/2); //lower right

  //Update the original value modifier and ratio
  diff++;
  delta += 0.01;
  if(delta > 1.0)
  {
    delta = -1.0;
    diff = 0;
  }
  
  text(diff,180,180);
}

