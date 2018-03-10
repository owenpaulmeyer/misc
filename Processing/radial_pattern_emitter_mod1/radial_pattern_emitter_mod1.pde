
int f = 400; 
int automate = 10;
float col = 255;

void setup() {
  size(800,800); 
  stroke(255,120);
  
  smooth();
  strokeWeight( 1 );
  background( 0 );
  
}

void draw(){
  fill(0,15);
  rect( 0, 0, width, height );
//fill(255,20);
  automate++;

 
beginShape();
  
  for( float idx = f ; idx > 0; idx -= .05 ) // k ranges from 550 to 0.1 

  {

//         stroke( col );
//    col =col -.01;
 
    float a =                          
       
      idx *                              // k ranges from 550 to 0.1 
      ( automate )       
      *.0001;

    
    vertex(
      f +                              // middle of the box
      
                                       // an offset that ranges from zero to 550
      cos( a ) *                         
                                       
      idx *
      sin( idx* 1.1 ),                          // zero to one, cycling as the loop moves on
      
      f + 
      sin( a )* idx *sin( idx )                  // another similar offset from the center

    );
           
    
  } 
  

 endShape(); 

}


