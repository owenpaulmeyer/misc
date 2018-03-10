class block {
 
  int num_points =  8;
  int num_edges  = 12;
  int num_faces  =  6;
  int num_edges_per_face = 4;
  
  //fields
  float [][] points = new float[num_points][3];
  int   [][] edges  = new int[num_edges][2];
  int   [][] faces  = new int[num_faces][num_edges_per_face];
 
  
 
  //constructor
  block(int wide, int high, int deep,int location_x,int location_y,int location_z){
   
    // the first parameter in the points array is the point #, the second is the x y or z value
    points[0][0]= location_x-wide/2;
    points[0][1]= location_y-high/2;
    points[0][2]= location_z+deep/2;
   
    points[1][0]= location_x+wide/2;
    points[1][1]= location_y-high/2;
    points[1][2]= location_z+deep/2;
   
    points[2][0]= location_x+wide/2;
    points[2][1]= location_y+high/2;
    points[2][2]= location_z+deep/2;
   
    points[3][0]= location_x-wide/2;
    points[3][1]= location_y+high/2;
    points[3][2]= location_z+deep/2;
   
    points[4][0]= location_x-wide/2;
    points[4][1]= location_y-high/2;
    points[4][2]= location_z-deep/2;
   
    points[5][0]= location_x+wide/2;
    points[5][1]= location_y-high/2;
    points[5][2]= location_z-deep/2;
   
    points[6][0]= location_x+wide/2;
    points[6][1]= location_y+high/2;
    points[6][2]= location_z-deep/2;
   
    points[7][0]= location_x-wide/2;
    points[7][1]= location_y+high/2;
    points[7][2]= location_z-deep/2;
   
    //the first parameter in the edges array is the edge #, the second is the point pair
    edges[0][0]= 0;
    edges[0][1]= 4;
   
    edges[1][0]= 1;
    edges[1][1]= 5;
   
    edges[2][0]= 2;
    edges[2][1]= 6;
   
    edges[3][0]= 3;
    edges[3][1]= 7;
   
    edges[4][0]= 0;
    edges[4][1]= 1;
   
    edges[5][0]= 4;
    edges[5][1]= 5;
   
    edges[6][0]= 6;
    edges[6][1]= 7;
   
    edges[7][0]= 2;
    edges[7][1]= 3;
   
    edges[8][0]= 0;
    edges[8][1]= 3;
   
    edges[9][0]= 1;
    edges[9][1]= 2;
   
    edges[10][0]= 5;
    edges[10][1]= 6;
   
    edges[11][0]= 4;
    edges[11][1]= 7;
   
    //the first parameter in the faces array is the face #, the second is the edge group
    faces[0][0]= 0;
    faces[0][1]= 5;
    faces[0][2]= 1;
    faces[0][3]= 4;
   
    faces[1][0]= 5;
    faces[1][1]= 10;
    faces[1][2]= 6;
    faces[1][3]= 11;
   
    faces[2][0]= 2;
    faces[2][1]= 6;
    faces[2][2]= 3;
    faces[2][3]= 7;
   
    faces[3][0]= 9;
    faces[3][1]= 7;
    faces[3][2]= 4;
    faces[3][3]= 8;
   
    faces[4][0]= 0;
    faces[4][1]= 11;
    faces[4][2]= 3;
    faces[4][3]= 8;
   
    faces[5][0]= 1;
    faces[5][1]= 10;
    faces[5][2]= 2;
    faces[5][3]= 9;
  }

int num_faces () {
  return faces.length;
}

// returns an array of edge numbers, for a given face
int[] edges_for_face ( int face ) {
    int[] face_edges = new int[num_edges_per_face];
    for ( int edge_idx = 0; edge_idx < num_edges_per_face; edge_idx++ ) {
      face_edges[ edge_idx ] = faces[ face ][ edge_idx ]; 
    }
    return face_edges;
}

// returns an array of two arrays
// each sub array has [ x, y, z ] 
// one for each end-point of the edge
float[][] points_for_edge ( int edge ) {
    float[][] edge_points = new float[2][3];
    for ( int point_idx = 0; point_idx < 2; point_idx++ ) {
      for ( int dimension_idx = 0; dimension_idx < 3; dimension_idx++ ) {
        edge_points[point_idx][dimension_idx] = points[ edges[ edge ][ point_idx ] ][ dimension_idx ];
      }
    }
    return edge_points;
}


//void intersect(){
//  float [][][][] pairs;
////  float u_x;
////  float u_y;
////  float u_z;
////  float v_x;
////  float v_y;
////  float v_z;
////  int face;
////  int edge;
//
//  int points;
//  for (int face= 0; face< 6; face++){
//    for (int edge= 0; edge< 4; edge++){
//      for (int poin= 0; poin< 2; poin++){
//        for (int xyz= 0; xyz< 3; xyz++){
// //         pairs[face][edge][poin][xyz]= points[ edges[ faces[ face ][ edge ] ][ poin ] ][ xyz ];
//        }}}}
//       
//       
//}
};

void setup() {
  block bb = new block( 1, 1, 1, 10, 10, 10 );
  println( "number of faces: " + bb.num_faces() );
  
  int[] face_zero_edges = bb.edges_for_face(0);
  for ( int edge_idx = 0; edge_idx < face_zero_edges.length; edge_idx++ ) {
    println( edge_idx + " edge of zeroth face is: " + face_zero_edges[ edge_idx ] );
    float [][] points_for_edge = bb.points_for_edge( face_zero_edges[ edge_idx ] );
    for ( int point_idx = 0; point_idx < 2; point_idx++ ) {
      println( point_idx + " point of " + edge_idx + " edge: " );
      for ( int dim_idx = 0; dim_idx < 3; dim_idx++ ) {
        println( "   " + dim_idx + " dimension: " + points_for_edge[ point_idx ][ dim_idx ] ); 
      }
    }
  }
}

