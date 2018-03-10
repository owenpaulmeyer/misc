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
int R = 20;
int G = 5;
int B = 33;
int incR = 1;
int incG = 1;
int incB = 1;
int RR = 170;
int GG = 150;
int BB = 200;
int incRR = 1;
int incGG = 1;
int incBB = 1;

void setup() {
  size( 800, 800 ); 
  
  
  smooth();
  strokeWeight( 1 );
  background( 0 );
  
}

void draw(){
  
  println("R: " + R );
  println("G: " + G );
  println("B: " + B );
  println("RR: " + RR );
  println("GG: " + GG );
  println("BB: " + BB );
   
  fill( 250, GG, BB, 10);
  rect( 0, 0, width, height );
  noFill();
  //background( 0 );
  automate ++;
  
  RR = RR - incRR;
  GG = GG - incGG;
  BB = BB - incBB;
  
    if( (RR < 100) || (RR > 254) ){
    incRR = incRR * -1;
  }
    if( (GG < 100) || (GG > 254) ){
    incGG = incGG * -1;
  }
    if( (BB < 100) || (BB > 254) ){
    incBB = incBB * -1;
  }
  
    
  R = R - incR;
  G = G - incG;
  B = B - incB;
  
  if( (R < 1) || (R > 80) ){
    incR = incR * -1;
  }
    if( (G < 1) || (G > 80) ){
    incG = incG * -1;
  }
    if( (B < 1) || (B > 254) ){
    incB = incB * -1;
  }
  stroke( R, G, B, 20 );
  
  

 
beginShape();
  
  for( float idx = sIze ; idx > 0; idx -= .05 ) {


      a = idx *  ( automate ) *.00012;
   
    vertex(
    
    //x coordinate
      sIze + cos( a *1.2 ) * idx * sin( idx * 1.003 ),  
      
     //y coordinate 
      sIze +  sin( a*3)* idx * sin( idx )    //for another nice effect try uncommenting the * sin( idx )         

    );  
  } 
  

 endShape(); 

}


