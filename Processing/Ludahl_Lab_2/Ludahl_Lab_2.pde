/*Created By: Brandon Ludahl
 *Processing Lab 2
 *Naima Lowe
 *October 12th, 2010
*/

/*Simple pair class*/
class Float_Pair
{
  float x, y;
  Float_Pair(float X, float Y)
  {
    x = X;
    y = Y;
  }
}

/*Hexagon object to be created and then displayed as desired*/
class Hexagon
{
  Float_Pair points[];
  Float_Pair origin;
  float radius;
  float rot;
  
  Hexagon(float x, float y, float diameter, float orientation)
  {
    points = new Float_Pair[6];
    origin = new Float_Pair(x,y);
    radius = diameter/2;
    rot = orientation;
    initialize();
  }
  
  void initialize()
  {
    for(int i = 0; i < 6; i += 1)
    {
      points[i] = new Float_Pair(radius*sin(PI*(i/3.0f)+rot)+origin.x,
                                 radius*cos(PI*(i/3.0f)+rot)+origin.y);
    }
  }
  
  void display(float offset_x, float offset_y)
  {
    fill(255,0,255);
    beginShape();
    for(int i = 0; i < 6; i++)
      vertex(points[i].x+offset_x,points[i].y+offset_y);
    endShape(CLOSE);
  }
}

/*Line-based animation class - circular radii expand and contract*/
class Explosion
{
  float x;
  float y;
  float radius;
  float speed;
  int explosion_frame;
  boolean grow_not_shrink;
  color c1;
  
  Explosion(float origin_x, float origin_y, float diameter)
  {
    x = origin_x;
    y = origin_y;
    radius = diameter/2;
    explosion_frame = 0;
    grow_not_shrink = true;
  }

  void drawExplosion(boolean pause)
  {
    stroke(c1);
    for(float i = 0; i < 100; i++)
    {
      line(x,y,
           (radius+explosion_frame)*sin(PI*(i/50))+x,
           (radius+explosion_frame)*cos(PI*(i/50))+y);
    }

    if(!pause)
      if(grow_not_shrink)
        if(explosion_frame < 99)
        {
          explosion_frame++;
        }
        else
          grow_not_shrink = false;
      else
        if(explosion_frame > 0)
        {
          explosion_frame--;
        }
        else
          grow_not_shrink = true;
  }
}

/*Simple function to draw colored rectangles for a static composition*/
void drawRects()
{
  fill(0,255,128);
  beginShape();
  vertex(100, height - 30);
  vertex(100, height - 50);
  vertex(355, height - 50);
  vertex(355, height - 30);
  endShape(CLOSE);
  
  fill(67,255,128);
  beginShape();
  vertex(50, height - 70);
  vertex(50, height - 90);
  vertex(305, height - 90);
  vertex(305, height - 70);
  endShape(CLOSE);
  
  fill(133,255,128);
  beginShape();
  vertex(100, height - 110);
  vertex(100, height - 130);
  vertex(355, height - 130);
  vertex(355, height - 110);
  endShape(CLOSE);
}

Explosion f1 = new Explosion(100,100,30);
Hexagon h1 = new Hexagon(50,50,20,0);

boolean stop_not_go; //If mouse is pressed, then pause animation.

void setup()
{
  size(400,400);
  colorMode(HSB, 255); //Not necessary, but desired for this file.
}

void draw()
{
  background(255);
  if(mousePressed)
    stop_not_go = true;
  else
    stop_not_go = false;

  for(int i = 0; i < 200; i+=20)
    for(int j = 0; j < 200; j+=20)
      h1.display(i+j/2,j-(j/10+j/20));
  f1.drawExplosion(stop_not_go);
  drawRects();
}



