
int sIze = 400; 
int automate = 0;
float col = 255;
float a = 0;

void setup() {
  size( 800, 800 ); 
  stroke( 255 ,88 );
  
  smooth();
  strokeWeight( 1 );
  background( 0 );
  
}

void draw(){
  fill(0,15);
  rect( 0, 0, width, height );
  noFill();
  automate ++;

 
beginShape();
  
  for( float idx = sIze ; idx > 0; idx -= .05 ) {

      a = idx *  ( automate ) *.0001;
   
    vertex(
    
    //x coordinate
      sIze + cos( a *1.1 ) * idx * sin( idx * 1.1 ),  
      
     //y coordinate 
      sIze +  sin( a )* idx * sin( idx )                

    );  
  } 
  

 endShape(); 

}


