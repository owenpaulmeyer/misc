int w=500,f=w/2; //Sets w to 500, f to width divided by 2

void setup() {
  size(500,500); // Window Size
  stroke(70,90,140);
}

void draw(){
  

  
  for( float k=f*1.2; k > 0; k -= .1 ) // k ranges from 550 to 0.1 

  {
   
    
    float a =                          // a ranges from 74250 to 
       
      k *                              // k ranges from 550 to 0.1 
      ( mouseY - mouseX * 270 )        // value in parens will range from -135000 to 500 
      *.0001;

    
    point(
      f +                              // middle of the box
      
                                       // an offset that ranges from zero to 550
      cos(a) *                         // zero to one, varies wildly, by mouse position,
                                       // more eratically by x mouse motion
                                       
      k *
      sin(k),                          // zero to one, cycling as the loop moves on
      
      f + 
      sin(a)*k*sin(k)                  // another similar offset from the center

    );
           stroke(k,k,f);
    
  } // to get a fractal like image produced you must use trig
  
//  filter(11); // bigger dot, any other value gives strange movement within fractal like image
//  blend(0,0,w,w,-2,2,w+3,w-5,1); //Blend to black after making fractal
  

}


