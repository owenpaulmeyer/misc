Complex points[];
DrawGraphSquare graph;
void setup()
{
  size(800,800);
  points = new Complex[49];
  for(int i = -3; i < 4; i++)
    for(int j = -3; j < 4; j++)
      points[(i+3)*7 + j+3] = new Complex(j,i);
  graph = new DrawGraphSquare(0,0,800,800);
  graph.displaySetup();
  translate(width/2.0,height/2.0);
  scale(1.0,-1.0);
  scale(5.0,5.0);
  stroke(0);
  graph.drawPoints();
  //graph.drawShape();
}


//Test Cases
//  points (15)
//  int total =0;
//  for(int i = 0; i < 6; i++)
//    for(int j = 0; j < i; j++)
//    {
//      points[total] = new Complex(j,i);
//      total++;
//    }

//  points (36)
//  for(int i = 0; i < 6; i++)
//    for(int j = 0; j < 6; j++)
//      points[i*6 + j] = new Complex(j,i);

//  points (10000)
//  for(int i = 0; i < 100; i++)
//    for(int j = 0; j < 100; j++)
//      points[i*100 + j] = new Complex(j*.1,i*.1);
