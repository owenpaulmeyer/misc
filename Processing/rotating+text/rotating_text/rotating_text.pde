// The message to be displayed
String message = "A r t    N e w    M e d i a";

PFont f;
// The radius of a circle
float r = 200;
float word_rotate;
float char_rotate;
void setup() {
  size(500, 500);
  f = loadFont("Gabriola-80.vlw");
  textFont(f);
  // The text must be centered!
  textAlign(CENTER);
  smooth();
}

void draw() {
  background(255);

  // Start in the center and draw the circle
  translate(width / 2, height / 2);
  noFill();
  stroke(0);
 

  // We must keep track of our position along the curve
  float arclength = 0;
    
  rotate(word_rotate);
  word_rotate += .008;
   char_rotate-=.03;

  // For every box
  for (int i = 0; i < message.length(); i++)
  {
    // Instead of a constant width, we check the width of each character.
    char currentChar = message.charAt(i);
    float w = textWidth(currentChar);

    // Each box is centered so we move half the width
    arclength += w/2;
    // Angle in radians is the arclength divided by the radius
    // Starting on the left side of the circle by adding PI
    float theta = PI + arclength / r;
    pushMatrix();
    // Polar to cartesian coordinate conversion
    translate(r*cos(theta), r*sin(theta));
    // Rotate the box
    rotate(theta+PI/2); // rotation is offset by 90 degrees
    // Display the character
    fill(0);
    rotate(char_rotate);
    pushMatrix();
    translate(0,20);
    textAlign(CENTER);
    text(currentChar,0,0);
    popMatrix();
    popMatrix();
    // Move halfway again
    arclength += w/2;
    
  }

  

}


