void rotation( float theta, float x_r, float y_r, String axis ){
  int a;
  int b;
  if( axis.equals("z") ){
    a = 0;
    b = 1;
  }
  if( axis.equals("x") ){
    a = 1;
    b = 2;
  }
  if( axis.equals("y") ){
    a = 2;
    b = 0;
  }  
  for( int point_idx = 0; point_idx < 8; point_idx ++){
    points_coordinates[ point_idx ][ a ] = ( points_coordinates[ point_idx ][ a ] * cos( theta ) ) + ( points_coordinates[ point_idx ][ b ] * -sin( theta ) ) + ( x_r * ( 1 - cos( theta ) ) + y_r * sin( theta ) );
    points_coordinates[ point_idx ][ b ] = ( points_coordinates[ point_idx ][ a ] * sin( theta ) ) + ( points_coordinates[ point_idx ][ b ] *  cos( theta ) ) + ( y_r * ( 1 - cos( theta ) ) - x_r * sin( theta ) );
  }
}
