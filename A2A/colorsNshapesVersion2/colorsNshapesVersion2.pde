//Owen Meyer
//dot-color medley
//version 2; dot retains color of previous quadrant


color cyan = color( 93, 255, 251 );
color yellow = color( 255, 255, 0 );
color greeen = color( 21, 149, 65 );
color magenta = color( 250, 10, 250 );
int colorKeeper = 2;         //stores which quadrant the dot just came from
color setIt;    //is used to pass the new color from the last quadrant into fill()

void setup() {
  size( 400, 400 );     //screen size
  strokeWeight( 2 );    //line thickness ( unecessary since 1 is default )

  smooth();             //antialiasing ( wu algorithm )
  rectMode( CENTER );   //first two parameters of rect() will designate the center of the rectangle
}

void draw() {
  //  stroke(100);
  //  strokeWeight( 1  );
  //noStroke();
  strokeWeight( 1 );
  fill( cyan, 40 );                             //the color w/ opacity (creates the fade)
  rect( width*.25, height*.25, width/2, height/2 );   //rectangle upper left
  fill( magenta, 40 );
  rect( width*.75, height*.75, width/2, height/2 );   //rectangle lower right

  fill( yellow, 40 );                              
  rect( width*.75, height*.25, width/2, height/2 );   //rectangle upper right
  fill( greeen, 40 );
  rect( width*.25, height*.75, width/2, height/2 );   //rectangle lower left


  fill( setIt );  //it is necessary to set the fill here because the colorKeeper will change to the next setting
                //at the end of the quadrant conditional; just before this fill() the previous one will be
                //fill( greeen, 40 ); from just above. here it is set to the appropriate color from the
                //conditionals below.  it cant be set inside the conditionals.
                
  if( mouseX < width/2 && mouseY < height/2 ) {       //upper left conditional
    if( colorKeeper == 2 ) {
      setIt = yellow;  
    }
    if(colorKeeper== 3) {
      setIt = greeen;
    }
    colorKeeper = 1;
  }
  
  
  if( mouseX < width/2 && mouseY > height/2 ) {       //lower left 
    if( colorKeeper == 4 ) {
      setIt = magenta;
    }
    if( colorKeeper == 1 ) {
      setIt = cyan;
    }
    colorKeeper = 3;
  }
  
  
  if( mouseX > width/2 && mouseY < height/2 ) {       //upper right
    if( colorKeeper == 1 ) {
      setIt  = cyan;
    }
    if( colorKeeper == 4) {
      setIt = magenta;
    }
    colorKeeper = 2;
  }
  
  
  if( mouseX > width/2 && mouseY > height/2 ) {       //lower right
    if( colorKeeper == 3 ) {    
      setIt = greeen;
    }
    if( colorKeeper == 2) {
      setIt = yellow;
    }
    colorKeeper = 4;
  }
  
  ellipse( mouseX, mouseY, 90, 90 );
  
  stroke( 80 );
  strokeWeight( 2 );

  line( width/2, 0, width/2, height );                //draws the reticle over everything
  line( 0, height/2, width, height/2 );
}

