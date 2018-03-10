
import processing.opengl.*;



class cross_section {
  
  //test for and create cross section per block***********************************CROSS SECTION*****************************************************************************
//for a block 'cube_1'

 float[] section_edges = new float[ 0 ];                 //array of resulting points of an edge per face [xyz_coordinates0-1]
 
 int parent_edge_number = 0;
 int parent_edge_number_first = 0;
 int new_face = 0;
 boolean full_circle = false;
 boolean loop_check = false;
 int loop_cnt = 0;

 cross_section( block cube_input ) {
 for( int face_idx = 0; face_idx < 6; face_idx++ ) {                                          //cycles through faces of block
   //    println( "face: " + face_idx ); //debug

   int[] current_face_edges = cube_input.edges_for_face( face_idx );                            //get edges for current face
   int point_section_count = 0;                           //to keep track of number of point intersections per face (here it is reset to 0 each iteration of the face_idx loop)

   for( int edge_idx = 0; edge_idx < 4 && point_section_count < 2; edge_idx++ ) {              //cycle through edges of current face until 2 intersections are found
     //      println( "  edge: " + edge_idx ); //debug

     float[][] points_seg = cube_input.points_for_edge( current_face_edges[ edge_idx ] );      //gets the points' coordinates for current edge

     // debug:
     //      println( "  edge point 0: " );
     //      println( points_seg[0] );
     //      println( "  edge point 1: " );
     //      println( points_seg[1] );

     float[] seg_intersection = intersect_lineseg_plane( points_seg[0], points_seg[ 1 ] );    //calcs intersection of current edge w/ plane to "intersect"

     // debug
     //      println( "    intersecction: " );
     //      println( seg_intersection );


     if( seg_intersection[ 0 ] == 1 ) {         //1 means positive intersection, increase count/ track intersecting point for cross section edge connection
       //        println( "  * single point intersection, adding point to section_edges " );

       point_section_count ++;
       section_edges = append( section_edges, seg_intersection[ 1 ] );             //starts at [ 1 ], [ 0 ] is test_value.  populates section_edges with coordinates
       section_edges = append( section_edges, seg_intersection[ 2 ] );
       section_edges = append( section_edges, seg_intersection[ 3 ] );
       parent_edge_number = current_face_edges[ edge_idx ];      //assigns the parent edge number
       parent_edge_number_first = current_face_edges[ edge_idx ];
       

       //        println( "now we have " + section_edges.length / 3 + " intersection points saved up" );
     }
     if( seg_intersection[ 0 ] == 2 ) {
       //         println( " * whole edge line is an intersection what the fuck do i do now." );
       //edge lies in plane
       //end loop
     }
     if( seg_intersection[ 0 ] == 0 ) {
       //        println( " * no intersection, do nothing" );
     }
   }         // edges loop
   if( point_section_count == 2 ) {
     new_face = face_idx;        //tags a face number onto the face array for the if a segment has just been found
     face_idx = 6;                   //ends the cycling through faces now that a segment has been found (and the parent_edge_number and parent_face's have been assigned
     }
   
 }       // faces loop

//
// println( "parent_face: " + parent_face );
// println( "parent_edge_number: " + parent_edge_number );
// new_face = cube_input.next_face_for_edge( parent_edge_number, parent_face );
// println( "new_face: " + new_face );
// exit();



while( !full_circle && loop_cnt < 6 ) {
  
  loop_cnt ++;

   int[] current_face_edges = cube_input.edges_for_face( new_face );                            //get edges for current face

   for( int edge_idx = 0; edge_idx < 4; edge_idx++ ) {              //cycle through edges of new_face
     int current_edge = current_face_edges[ edge_idx ];
     if( current_edge != parent_edge_number ) {
       //gets the points' coordinates for current edge
       float[][] points_seg = cube_input.points_for_edge( current_face_edges[ edge_idx ] );

       //calcs intersection of current edge w/ plane to "intersect"
       float[] seg_intersection = intersect_lineseg_plane( points_seg[0], points_seg[ 1 ] );
       
       if( seg_intersection[ 0 ] == 0 ) {
//         println( "" );
//         println( "seg_intersection:  " + seg_intersection[ 0 ] );
//         break;        
       }
//       println( "here now" );
//       println( edge_idx );
//       println( "new_face:  " + new_face );
//       println( "current_edge: " + current_edge );
//       println( "old new_face: " + new_face );
//       println( "parent_edge_number:  "  + parent_edge_number );
       

       if( seg_intersection[ 0 ] == 1 ) {         //1 means positive intersection, increase count/ track intersecting point for cross section edge connection
         section_edges = append( section_edges, seg_intersection[ 1 ] );             //starts at [ 1 ], [ 0 ] is test_value.  populates section_edges with coordinates
         section_edges = append( section_edges, seg_intersection[ 2 ] );
         section_edges = append( section_edges, seg_intersection[ 3 ] );

         parent_edge_number = current_edge;      //assigns the parent edge number
         edge_idx = 4;

//         println( "current_edge: " + current_edge );
//         println( "old new_face: " + new_face );//debug
         

         new_face = cube_input.next_face_for_edge( current_edge, new_face );
//
//         println( "new new_face: " + new_face );//debug
//         println( "" );
//         println( section_edges.length );

         if( parent_edge_number == parent_edge_number_first ) {
           full_circle = true;
         }
       }
     }
   }
 }

}//cross_section()

};



class xyz_coordinate {
 float x;
 float y;
 float z;

 xyz_coordinate( float x_, float y_, float z_ ) {
   x = x_;
   y = y_;
   z = z_;
 }
};



class block {

 int num_points =  8;
 int num_edges  = 12;
 int num_faces  =  6;
 int num_edges_per_face = 4;

 //fields
 float [][] points_coordinates = new float[ num_points ][ 3 ];
 int   [][] edges_points  = new int[ num_edges ][ 2 ];
 int   [][] faces_edges  = new int[ num_faces ][ num_edges_per_face ];



 //constructor inputs width, height, depth, location x, y, z
 block( int wide, int high, int deep,int location_x,int location_y,int location_z ) {

   // the first parameter in the points_coordinates array is the point #, the second is the x y or z value
   points_coordinates[0][0]= location_x-wide/2;
   points_coordinates[0][1]= location_y-high/2;
   points_coordinates[0][2]= location_z+deep/2;

   points_coordinates[1][0]= location_x+wide/2;
   points_coordinates[1][1]= location_y-high/2;
   points_coordinates[1][2]= location_z+deep/2;

   points_coordinates[2][0]= location_x+wide/2;
   points_coordinates[2][1]= location_y+high/2;
   points_coordinates[2][2]= location_z+deep/2;

   points_coordinates[3][0]= location_x-wide/2;
   points_coordinates[3][1]= location_y+high/2;
   points_coordinates[3][2]= location_z+deep/2;

   points_coordinates[4][0]= location_x-wide/2;
   points_coordinates[4][1]= location_y-high/2;
   points_coordinates[4][2]= location_z-deep/2;

   points_coordinates[5][0]= location_x+wide/2;
   points_coordinates[5][1]= location_y-high/2;
   points_coordinates[5][2]= location_z-deep/2;

   points_coordinates[6][0]= location_x+wide/2;
   points_coordinates[6][1]= location_y+high/2;
   points_coordinates[6][2]= location_z-deep/2;

   points_coordinates[7][0]= location_x-wide/2;
   points_coordinates[7][1]= location_y+high/2;
   points_coordinates[7][2]= location_z-deep/2;

   //the first parameter in the edges_points array is the edge #, the second is the point pair
   edges_points[0][0]= 0;
   edges_points[0][1]= 4;

   edges_points[1][0]= 1;
   edges_points[1][1]= 5;

   edges_points[2][0]= 2;
   edges_points[2][1]= 6;

   edges_points[3][0]= 3;
   edges_points[3][1]= 7;

   edges_points[4][0]= 0;
   edges_points[4][1]= 1;

   edges_points[5][0]= 4;
   edges_points[5][1]= 5;

   edges_points[6][0]= 6;
   edges_points[6][1]= 7;

   edges_points[7][0]= 2;
   edges_points[7][1]= 3;

   edges_points[8][0]= 0;
   edges_points[8][1]= 3;

   edges_points[9][0]= 1;
   edges_points[9][1]= 2;

   edges_points[10][0]= 5;
   edges_points[10][1]= 6;

   edges_points[11][0]= 4;
   edges_points[11][1]= 7;

   //the first parameter in the faces_edges array is the face #, the second is the edge group
   faces_edges[0][0]= 0;
   faces_edges[0][1]= 5;
   faces_edges[0][2]= 1;
   faces_edges[0][3]= 4;

   faces_edges[1][0]= 5;
   faces_edges[1][1]= 10;
   faces_edges[1][2]= 6;
   faces_edges[1][3]= 11;

   faces_edges[2][0]= 2;
   faces_edges[2][1]= 6;
   faces_edges[2][2]= 3;
   faces_edges[2][3]= 7;

   faces_edges[3][0]= 9;
   faces_edges[3][1]= 7;
   faces_edges[3][2]= 4;
   faces_edges[3][3]= 8;

   faces_edges[4][0]= 0;
   faces_edges[4][1]= 11;
   faces_edges[4][2]= 3;
   faces_edges[4][3]= 8;

   faces_edges[5][0]= 1;
   faces_edges[5][1]= 10;
   faces_edges[5][2]= 2;
   faces_edges[5][3]= 9;
 }

 int num_faces () {
   return faces_edges.length;
 }

 // returns an array of edge numbers, for a given face

 int[] edges_for_face ( int face ) {                 //inputs a face number to get edge numbers from faces_edges array
   int[] face_edges = new int[ num_edges_per_face ];    //initializes array to recieve edge numbers
   for ( int edge_idx = 0; edge_idx < num_edges_per_face; edge_idx++ ) {    //cycles through 4 edges
     face_edges[ edge_idx ] = faces_edges[ face ][ edge_idx ];       //assigns an edge number per edge index
   }
   return face_edges;
 }

 // returns an array of two arrays
 // each sub array has [ x, y, z ]
 // one for each end-point of the edge

 float[][] points_for_edge ( int edge ) {   //inputs an edge number to retrieve coordinates
   float[][] edge_points = new float[2][3];   //initializes array to recieve coordinates per point number
   for ( int point_idx = 0; point_idx < 2; point_idx++ ) {     //cycles through two points of one edge
     for ( int coordinate_idx = 0; coordinate_idx < 3; coordinate_idx++ ) {    //cycles through three coordinates of one point
       edge_points[ point_idx ][ coordinate_idx ] = points_coordinates[ edges_points[ edge ][ point_idx ] ][ coordinate_idx ];    //assigns coordinate value per point per coordinate index
     }
   }
   return edge_points;
 }

 void rotation( float theta, float x_r, float y_r, String axis ) {
   int a = 0;
   int b = 1;
   if( axis == "z" ) {
     a = 0;
     b = 1;
   }
   if( axis == "x" ) {
     a = 1;
     b = 2;
   }
   if( axis == "y" ) {
     a = 2;
     b = 0;
   }
   for( int point_idx = 0; point_idx < 8; point_idx ++) {
     float pass_x = ( points_coordinates[ point_idx ][ a ] * cos( theta ) )
       + ( points_coordinates[ point_idx ][ b ] * -sin( theta ) )
         + ( x_r * ( 1 - cos( theta ) ) + y_r * sin( theta ) );
     float pass_y = ( points_coordinates[ point_idx ][ a ] * sin( theta ) )
       + ( points_coordinates[ point_idx ][ b ] *  cos( theta ) )
         + ( y_r * ( 1 - cos( theta ) ) - x_r * sin( theta ) );
     points_coordinates[ point_idx ][ a ] = pass_x;
     points_coordinates[ point_idx ][ b ] = pass_y;
   }
 }
 
 float center( String coord ) {
    float[] center_coordinates = new float[ 3 ];
    center_coordinates[ 0 ] = ( points_coordinates[ 0 ][ 0 ] +
                                points_coordinates[ 1 ][ 0 ] +
                                points_coordinates[ 2 ][ 0 ] +
                                points_coordinates[ 3 ][ 0 ] +
                                points_coordinates[ 4 ][ 0 ] +
                                points_coordinates[ 5 ][ 0 ] +
                                points_coordinates[ 6 ][ 0 ] +
                                points_coordinates[ 7 ][ 0 ] ) / 8;
                              
    center_coordinates[ 1 ] = ( points_coordinates[ 0 ][ 1 ] +
                                points_coordinates[ 1 ][ 1 ] +
                                points_coordinates[ 2 ][ 1 ] +
                                points_coordinates[ 3 ][ 1 ] +
                                points_coordinates[ 4 ][ 1 ] +
                                points_coordinates[ 5 ][ 1 ] +
                                points_coordinates[ 6 ][ 1 ] +
                                points_coordinates[ 7 ][ 1 ] ) / 8;
                              
    center_coordinates[ 2 ] = ( points_coordinates[ 0 ][ 2 ] +
                                points_coordinates[ 1 ][ 2 ] +
                                points_coordinates[ 2 ][ 2 ] +
                                points_coordinates[ 3 ][ 2 ] +
                                points_coordinates[ 4 ][ 2 ] +
                                points_coordinates[ 5 ][ 2 ] +
                                points_coordinates[ 6 ][ 2 ] +
                                points_coordinates[ 7 ][ 2 ] ) / 8;  
                              
    if( coord == "x" ) {
      return center_coordinates[ 0 ];
    }
    
    if( coord == "y" ) {
      return center_coordinates[ 1 ];
    }
    
    if( coord == "z" ) {
      return center_coordinates[ 2 ];
    }
    else {
      return 3;
    }
                                
  
 } 

 void display() {

   stroke( 252, 64, 231 );
   strokeWeight( 1 );
   beginShape();
   vertex( points_coordinates[ 0 ][ 0 ], points_coordinates[ 0 ][ 1 ], points_coordinates[ 0 ][ 2 ] );
   vertex( points_coordinates[ 1 ][ 0 ], points_coordinates[ 1 ][ 1 ], points_coordinates[ 1 ][ 2 ] );
   vertex( points_coordinates[ 5 ][ 0 ], points_coordinates[ 5 ][ 1 ], points_coordinates[ 5 ][ 2 ] );
   vertex( points_coordinates[ 4 ][ 0 ], points_coordinates[ 4 ][ 1 ], points_coordinates[ 4 ][ 2 ] );
   endShape(CLOSE);



   beginShape();
   vertex( points_coordinates[ 5 ][ 0 ], points_coordinates[ 5 ][ 1 ], points_coordinates[ 5 ][ 2 ] );
   vertex( points_coordinates[ 1 ][ 0 ], points_coordinates[ 1 ][ 1 ], points_coordinates[ 1 ][ 2 ] );
   vertex( points_coordinates[ 2 ][ 0 ], points_coordinates[ 2 ][ 1 ], points_coordinates[ 2 ][ 2 ] );
   vertex( points_coordinates[ 6 ][ 0 ], points_coordinates[ 6 ][ 1 ], points_coordinates[ 6 ][ 2 ] );
   endShape(CLOSE);



   beginShape();
   vertex( points_coordinates[ 5 ][ 0 ], points_coordinates[ 5 ][ 1 ], points_coordinates[ 5 ][ 2 ] );
   vertex( points_coordinates[ 6 ][ 0 ], points_coordinates[ 6 ][ 1 ], points_coordinates[ 6 ][ 2 ] );
   vertex( points_coordinates[ 7 ][ 0 ], points_coordinates[ 7 ][ 1 ], points_coordinates[ 7 ][ 2 ] );
   vertex( points_coordinates[ 4 ][ 0 ], points_coordinates[ 4 ][ 1 ], points_coordinates[ 4 ][ 2 ] );
   endShape(CLOSE);



   beginShape();
   vertex( points_coordinates[ 2 ][ 0 ], points_coordinates[ 2 ][ 1 ], points_coordinates[ 2 ][ 2 ] );
   vertex( points_coordinates[ 3 ][ 0 ], points_coordinates[ 3 ][ 1 ], points_coordinates[ 3 ][ 2 ] );
   vertex( points_coordinates[ 7 ][ 0 ], points_coordinates[ 7 ][ 1 ], points_coordinates[ 7 ][ 2 ] );
   vertex( points_coordinates[ 6 ][ 0 ], points_coordinates[ 6 ][ 1 ], points_coordinates[ 6 ][ 2 ] );
   endShape(CLOSE);



   beginShape();
   vertex( points_coordinates[ 0 ][ 0 ], points_coordinates[ 0 ][ 1 ], points_coordinates[ 0 ][ 2 ] );
   vertex( points_coordinates[ 4 ][ 0 ], points_coordinates[ 4 ][ 1 ], points_coordinates[ 4 ][ 2 ] );
   vertex( points_coordinates[ 7 ][ 0 ], points_coordinates[ 7 ][ 1 ], points_coordinates[ 7 ][ 2 ] );
   vertex( points_coordinates[ 3 ][ 0 ], points_coordinates[ 3 ][ 1 ], points_coordinates[ 3 ][ 2 ] );
   endShape(CLOSE);



   beginShape();
   vertex( points_coordinates[ 0 ][ 0 ], points_coordinates[ 0 ][ 1 ], cube_1.points_coordinates[ 0 ][ 2 ] );
   vertex( points_coordinates[ 3 ][ 0 ], points_coordinates[ 3 ][ 1 ], cube_1.points_coordinates[ 3 ][ 2 ] );
   vertex( points_coordinates[ 2 ][ 0 ], points_coordinates[ 2 ][ 1 ], cube_1.points_coordinates[ 2 ][ 2 ] );
   vertex( points_coordinates[ 1 ][ 0 ], points_coordinates[ 1 ][ 1 ], cube_1.points_coordinates[ 1 ][ 2 ] );
   endShape(CLOSE);
 }

 boolean is_edge_in_face( int face, int edge_number ) {
   for( int edge_idx = 0; edge_idx < num_edges_per_face; edge_idx ++ ) {
     if( faces_edges[ face ][ edge_idx ] == edge_number ) {
       return true;
     }
   }
   return false;
 }

 int next_face_for_edge ( int parent_edge_number, int parent_face ) {
   for( int face_idx = 0; face_idx < 6; face_idx ++ ) {
     if( is_edge_in_face( face_idx, parent_edge_number ) == true && face_idx != parent_face ) {         //test for sans parent_face
       return face_idx;
 //       println( "new face" + new_face );//debug
     }
   }

   return 88;
 }
};


// returns a float[4] array:
// [ test_value, x, y, z ]
// result[0] == 0 :  no intersection; result[0] == 1 :  intersection is a point; result[0] == 2 :  intersection is the whole segment
// only on result[0] == 1 :  are x, y, z populated.

float[] intersect_lineseg_plane ( float[] point_a, float[] point_b ) {  //inputs 2 points as array for x,y,z
 float[] result = new float[ 4 ];                                           //array for intersect results

 PVector p0 = new PVector( point_a[ 0 ], point_a[ 1 ], point_a[ 2 ] );          //points for segment
 PVector p1 = new PVector( point_b[ 0 ], point_b[ 1 ], point_b[ 2 ] );

 // plane definition, made of the y & z axis
 PVector p_v0 = new PVector( 0, 0, 0 );  //point in plane
 PVector p_n  = new PVector( 1, 0, 0 );  //point for normal vector in x axis

 PVector u = new PVector( p1.x, p1.y, p1.z );  //copy for math
 u.sub( p0 );                                  //vector for segment
 PVector w = new PVector( p0.x, p0.y, p0.z );  //copy for math
 w.sub( p_v0 );                                //vector for angle testing

 float d = p_n.dot( u );   //dot products for the angles between vecters
 float n = - p_n.dot( w );

 if ( abs( d ) < 0.0000000001 ) {   //is segment parallel
   if ( n == 0 ) {                  //segment in plane
     result[ 0 ] = 2;
   }
   else {
     result[ 0 ] = 0;         //no intersecting value
   }
 }
 else {      // calculate intersection
   float sI = n / d;
   if ( sI < 0 || sI > 1 ) {    //whether segment intersects plane
     result[ 0 ] = 0;
   }
   else {
     result[ 0 ] = 1;   //positive intersection of segment and plane

     PVector intersect = new PVector( p0.x, p0.y, p0.z );   //vector copy for math
     u.mult( sI );
     intersect.add( u );
     result[ 1 ] = intersect.x;   //coordinates for intersecting point
     result[ 2 ] = intersect.y;
     result[ 3 ] = intersect.z;
   }
 }

 return result;
}





block cube_1 = new block( 100, 100 , 400,90,00,00 );
;
//float[] test = new float[ 4 ];

PImage back;


void setup() {
 size( 900, 900, P3D );
 lights(); 
 background( 211, 234, 223 );
 back = get();
 stroke( 0 );
 strokeWeight( 5 );
 smooth();


// testing:
//  int next_face = cube_1.next_face_for_edge( 0, 0 );
//  println( "next face should be four, and it's: " + next_face );
//  next_face = cube_1.next_face_for_edge( 8, 4 );
//  println( "next face should be three, and it's: " + next_face );
//
//  next_face = cube_1.next_face_for_edge( 6, 2 );
//  println( "next face should be one, and it's: " + next_face );
//
//  next_face = cube_1.next_face_for_edge( 3, 2 );
//  println( "next face should be four, and it's: " + next_face );
//
//  exit();

 cube_1.rotation( radians( 45 ), 0, 0, "z" );
 cube_1.rotation( radians( -35 ), 0, 0, "x" );

 translate( width / 2, height / 2 );
}

cross_section[] cross_sections_array = new cross_section[ 300  ];
cross_section cross_now;
int draw_spot = 0;
int snake_head=0;
int r = 12;
int g = 230;
int b = 123;

void draw() {
 lights();
 background( back );
 stroke( 0 );
 strokeWeight( 5 );
 
 
 snake_head++;
 
 cube_1.rotation( radians( -1.2),0,0, "x" );
 cube_1.rotation( radians( 1.2 ), cube_1.center( "y" ), cube_1.center( "z" ), "x" );
 cube_1.rotation( radians( -1.1 ), cube_1.center( "x" ), cube_1.center( "y" ), "z" );
  
  cross_section holder = new cross_section( cube_1 );
  
  
  cross_sections_array[ snake_head % 300 ] = holder;
 
color phil = color( 27, 100, 188, 210 );

if(snake_head > 300){
  
int snake_head_pass = snake_head;
  for( int idxx = 0; idxx < 400 ; idxx += 8 ) {
    snake_head_pass += 4;
    cross_now = cross_sections_array[ snake_head_pass % 300 ]; 
    noStroke();
//      stroke( 180 );
    
    if( idxx % 3 == 0 ){
      phil = color( 255);
    }
//    if( idxx % 3 == 1 ){
//      phil = color( 252, 233, 18 );
//    }
    fill( phil );
    strokeWeight( 1 );
    smooth();
    beginShape( TRIANGLE_FAN );
    //    float[] section_pass = cross_now.section_edges;
    for( int idx = 0; idx < cross_now.section_edges.length - 1; idx += 3 ) {
    vertex( idxx-200  , cross_now.section_edges[ idx+1 ], cross_now.section_edges[ idx+2 ] );
    
    }

    endShape( CLOSE );
    phil = color( 0 );
//    rotateZ( radians( .2) );
//    rotateX( radians(- .4) );
//    
    println( g );
   
  }
  
   
}

    

 //  cube_1.rotation( radians( 1 ), 0, 0, "z" );
 
  fill( 64, 252, 241, 88 );
// cube_1.display();



// r++;
//    g++;
//    b++;
//    r = ( r % 255 );
//    g = ( g % 255 );
//    b = ( b % 255 );

 


//back = get();
//exit();
 camera(mouseX, mouseY, 220.0, // eyeX, eyeY, eyeZ
 0.0, 0.0, 0.0, // centerX, centerY, centerZ
 0.0, 1.0, 0.0); // upX, upY, upZ

}
