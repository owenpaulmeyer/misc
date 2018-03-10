//for a block 'cube_1'

for(int face_idx = 0; face_idx < 6; face_idx++){
  int[] current_face = cube_1.edges_for_face( face_idx );
  for (int edge_idx = 0; edge_idx < 4; edge_idx++){
    float[][] intersect_points = cube_1.points_for_edge(edge_idx);
