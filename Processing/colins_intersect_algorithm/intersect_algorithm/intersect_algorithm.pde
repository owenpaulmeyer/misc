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
};


// returns a float[4] array:
// [ did_it_work, x, y, z ]
// did_it_work: 0 == no intersection; 1 = intersection is a point; 2 = intersection is the whole segment
//   only on did_it_work == 1 are x, y, z populated.
float[] intersect_lineseg_plane ( float[] point_a, float[] point_b ) {
 float[] result = new float[4];

 PVector p0 = new PVector( point_a[0], point_a[1], point_a[2] );
 PVector p1 = new PVector( point_b[0], point_b[1], point_b[2] );

 // plane definition, made of the y & z axis
 PVector p_v0 = new PVector( 0, 0, 0 );
 PVector p_n  = new PVector( 1, 0, 0 );

 PVector u = new PVector( p1.x, p1.y, p1.z );
 u.sub( p0 );
 PVector w = new PVector( p0.x, p0.y, p0.z );
 w.sub( p_v0 );

 float d = p_n.dot( u );
 float n = - p_n.dot( w );

 if ( abs( d ) < 0.0000000001 ) {
   if ( n == 0 ) {
     result[0]=2;
   }
   else {
     result[0]=0;
   }
 }
 else { // calculate intersection
   float sI = n / d;
   if ( sI < 0 || sI > 1 ) {
     result[0]=0;
   }
   else {
     result[0] = 1;

     PVector intersect = new PVector( p0.x, p0.y, p0.z );
     u.mult( sI );
     intersect.add( u );
     result[1] = intersect.x;
     result[2] = intersect.y;
     result[3] = intersect.z;
   }
 }

 return result;
}

void setup() {
  float[] test = new float[4];
  float[] input_1 = {-1,1,-1};
  float[] input_2 = {1,-3.68,-.78};
  
  test = intersect_lineseg_plane ( input_1,input_2 );
println(test);
}
