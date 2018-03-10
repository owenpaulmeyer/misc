class DrawGraphSquare
{
  float left_edge;
  float top_edge;
  float wide;
  float tall;
  float pos_real_axis;
  float pos_imaginary_axis;
  DrawGraphSquare(float global_x, float global_y,
                  float local_width, float local_height)
  {
    left_edge = global_x;
    top_edge = global_y;
    wide = local_width;
    tall = local_height;
    pos_real_axis = left_edge + local_width/2.0;
    pos_imaginary_axis = top_edge + local_height/2.0;
  }
  
  void displaySetup()
  {
    stroke(255,0,0);
    line(left_edge, pos_imaginary_axis, //left middle
         left_edge + wide, pos_imaginary_axis); //right middle
    line(pos_real_axis, top_edge, //top middle
         pos_real_axis, top_edge + tall); //bottom middle
  }
  
  void drawPoints()
  {
    for(int i = 0; i < points.length; i++)
    {
      Complex temp = mul(points[i], points[i]); //square function
      point(temp.re, temp.im);
    }
  }
  
  void drawShape()
  {
    for(int i = 0; i < points.length; i+=100)
    {
      noFill();
      beginShape();
      for(int j = 0; j < 100; j++)
      {
        Complex temp = mul(points[i + j], points[i + j]); //square function
        vertex(temp.re, temp.im);
      }
      endShape();
    }
  }
}
