//Owen Meyer
//the trig functions here are taken from another source and then modified (played with)  
//to achieve various excellent effects
//uncommenting the * sin( idx ) below produces another beautifull result
//
//this version continues to be interestingly ordered over time; 
// while a lot of variations become chaotic over time

int sIze = 400; //changes the size and centers the image
int automate = 222;
float col = 255;
float a = 0;

void setup() {
  size( 800, 800 ); 
  stroke( 255 ,30 );
  
  smooth();
  strokeWeight( 1 );
  background( 0 );
  
}

void draw(){
  fill(0,9);
  rect( 0, 0, width, height );
  noFill();
  automate ++;

 
beginShape();
  
  for( float idx = sIze ; idx > 0; idx -= .04 ) {

      a = idx *  ( automate ) *.0001;
   
    vertex(
    
    //x coordinate
      sIze + cos( a  ) * idx * cos( idx - (mouseX/10) ),  
      
     //y coordinate 
      sIze +  sin( a )* idx * cos( idx-(mouseY/10) )    //for another nice effect try uncommenting the * sin( idx )         

    );  
  } 
  

 endShape(); 

}


