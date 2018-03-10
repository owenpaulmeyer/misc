int w=500,f=w/2; //Sets w to 500, f to width divided by 2

void setup() {
  size(500,500); // Window Size
}

void draw(){
  stroke(70,90,140);
  for(float k=f*1.2;k>0;k-=.1) // Sets values of "k" to 

  {
float a=k*(mouseY-mouseX*270)*.0001;point(f+cos(a)*k*sin(k),f+sin(a)*k*sin(k));
  } // to get a fractal like image produced you must use trig
filter(11); // bigger dot, any other value gives strange movement within fractal like image
blend(0,0,w,w,-2,2,w+3,w-5,1); //Blend to black after making fractal

}


