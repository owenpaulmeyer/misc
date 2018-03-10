float[] cross_sections( block cube_input ){
  float[] section_edges = new float[ 0 ];                 //array of resulting points of an edge per face [xyz_coordinates0-1]
  int[] parent_face = new int[ 0 ];
  int[] parent_edge = new int[ 2 ];
  



  for( int face_idx = 0; face_idx < 6; face_idx++ ) {                                          //cycles through faces of block
    //    println( "face: " + face_idx ); //debug

    int[] current_face_edges = cube_input.edges_for_face( face_idx );                            //get edges for current face
    int point_section_count = 0;                           //to keep track of number of point intersections per face (here it is reset to 0 each iteration of the face_idx loop)

    for( int edge_idx = 0; edge_idx < 4 && point_section_count < 2; edge_idx++ ){              //cycle through edges of current face until 2 intersections are found
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


      if( seg_intersection[ 0 ] == 1 ){         //1 means positive intersection, increase count/ track intersecting point for cross section edge connection
        //        println( "  * single point intersection, adding point to section_edges " );

        point_section_count ++;
        section_edges = append( section_edges, seg_intersection[ 1 ] );             //starts at [ 1 ], [ 0 ] is test_value.  populates section_edges with coordinates
        section_edges = append( section_edges, seg_intersection[ 2 ] );
        section_edges = append( section_edges, seg_intersection[ 3 ] );
        parent_edge[ point_section_count -1 ] = current_face_edges[ edge_idx ];      //assigns the parent edge number to the parent_edge array at index 0 or 1 when a point has been found

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
      parent_face = append( parent_face, face_idx );        //tags a face number onto the face array for the if a segment has just been found
      face_idx = 6;                   //ends the cycling through faces now that a segment has been found (and the parent_edge and parent_face's have been assigned
    }   
    }       // faces loop
    for( int face_idx = 0; face_idx < 6; face_idx ++ ){
      if( cube_input.is_edge_in_face == true && face_idx != parent_face[ 0 ] ){
      }  
    }
         


    // debug:
    println( " holy fuck here are the section edges: ");
    println( section_edges );

    return section_edges;
  }

