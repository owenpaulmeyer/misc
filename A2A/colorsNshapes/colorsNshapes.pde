//Owen Meyer
//square circle color medley

void setup() {
  size( 400, 400 );     //screen size
  strokeWeight( 2 );    //line thickness ( unecessary since 1 is default )

  smooth();             //antialiasing ( wu algorithm )
  rectMode( CENTER );   //first two parameters of rect() will designate the center of the rectangle

}

void draw() {
//  stroke(100);
//  strokeWeight( 1  );
noStroke();

  fill( 0, 255, 255, 6 );                             //the color w/ 8 for opacity (creates the fade)
  rect( width*.25, height*.25, width/2, height/2 );   //rectangle upper left
  fill( 250, 10, 250, 7 );
  rect( width*.75, height*.75, width/2, height/2 );   //rectangle lower right

  fill( 255, 255, 0, 6 );                              
  rect( width*.75, height*.25, width/2, height/2 );   //rectangle upper right
  fill( 0, 255, 0, 6 );
  rect( width*.25, height*.75, width/2, height/2 );   //rectangle lower left
  
  

  if( mouseX < width/2 && mouseY < height/2 ) {       //upper left conditional to draw red circle
    fill( int(random(230,255)), int(random(110,120)), int(random(0,20)) );
    ellipse( mouseX, mouseY, 70, 70 );
  }
  if( mouseX < width/2 && mouseY > height/2 ) {       //lower left 
  fill( int(random(220,255)), int(random(0,30)), int(random(0,30)) );
    
    rect( mouseX, mouseY, 70, 70 );
  }
  if( mouseX > width/2 && mouseY < height/2 ) {       //upper right
    fill( int(random(0,20)), int(random(0,20)), int(random(230,255)) );
    rect( mouseX, mouseY, 70, 70 );
  }
  if( mouseX > width/2 && mouseY > height/2 ) {       //lower right
    fill( int(random(10,20)), int(random(190,200)), int(random(70,80)) );
    ellipse( mouseX, mouseY, 70, 70 );
  }

  stroke( 80 );


  line( width/2, 0, width/2, height );                //draws the reticle over everything
  line( 0, height/2, width, height/2 );
}

