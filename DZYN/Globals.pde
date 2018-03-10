  final Edge n = new Edge(0, -1);
  final Edge s = new Edge(0, 1);
  final Edge w = new Edge(-1, 0);
  final Edge e = new Edge(1, 0);
  final Edge nw = new Edge(-1, -1);
  final Edge ne = new Edge(1, -1);
  final Edge sw = new Edge(-1, 1);
  final Edge se = new Edge(1, 1);
  
  final ArrayList< Edge > directions( ) {
    ArrayList< Edge > directions = new ArrayList< Edge >( );
    directions.add( n );
    directions.add( s );
    directions.add( w );
    directions.add( e );
    directions.add( nw );
    directions.add( ne );
    directions.add( sw );
    directions.add( se );
    return directions;
  }

  //reflection is for helping to input graphs
  //Edge reflection is helper for nodeReflection
  final Edge reflectY( Edge edge ) {
    return new Edge( edge.x( ), edge.y( ) * -1 );
  }
  
  final Edge reflectX( Edge edge ) {
    return new Edge( edge.x( ) * -1, edge.y( ) );
  }

  double threshold( ) {
    return .45;
    
  }
  
Graph testInput( ) {
  Graph design = new Graph( 2, 2 );
  Node n1 = new Node( );
  n1.addEdge( s );
  n1.addEdge( e );
  n1.addEdge( se );
  design.addNode( 0, 0, n1 );
  design.addNode( 0, 4, n1.nodeReflectY( ) );
  design.addNode( 4, 0, n1.nodeReflectX( ) );
  design.addNode( 4, 4, n1.nodeReflectX( ).nodeReflectY( ) );
  Node n2 = new Node( );
  n2.addEdge( n );
  n2.addEdge( s );
  n2.addEdge( e );
  design.addNode( 0, 1, n2 );
  design.addNode( 0, 2, n2 );
  design.addNode( 0, 3, n2 );
  design.addNode( 4, 1, n2.nodeReflectX( ) );
  design.addNode( 4, 2, n2.nodeReflectX( ) );
  design.addNode( 4, 3, n2.nodeReflectX( ) );
  Node n3 = new Node( );
  n3.addEdge( w );
  n3.addEdge( e );
  n3.addEdge( s );
  design.addNode( 1, 0, n3 );
  design.addNode( 2, 0, n3 );
  design.addNode( 3, 0, n3 );
  design.addNode( 1, 4, n3.nodeReflectY( ) );
  design.addNode( 2, 4, n3.nodeReflectY( ) );
  design.addNode( 3, 4, n3.nodeReflectY( ) );
  Node n4 = new Node( n1 );
  n4.addEdge( nw );
  design.addNode( 3, 3, n4 );
  design.addNode( 1, 3, n4.nodeReflectX( ) );
  design.addNode( 3, 1, n4.nodeReflectY( ) );
  design.addNode( 1, 1, n4.nodeReflectY( ).nodeReflectX( ) );
  Node n5 = new Node( n4 );
  n5.addEdge( n );
  n5.addEdge( w );
  n5.addEdge( sw );
  n5.addEdge( ne );
  design.addNode( 2, 2, n5 );
  Node nv = new Node( );
  nv.addEdge( n );
  nv.addEdge( s );
  design.addNode( 2, 1, nv );
  design.addNode( 2, 3, nv );
  Node nh = new Node( );
  nh.addEdge( w );
  nh.addEdge( e );
  design.addNode( 1, 2, nh );
  design.addNode( 3, 2, nh );
  return design;
}

