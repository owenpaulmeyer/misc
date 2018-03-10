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
    //return .47;
    if (tuggle )return .499;//.499; //.52
    else return .43;
    //return .57; ******
    
    
  }
  
  Teeth compound( Teeth t1, Teeth t2 ){
    Teeth teeth = new Teeth( );
    for ( Tooth t : t2 ) teeth.addTooth( t );
    for ( Tooth t : t1 ) teeth.addTooth( t );
    return teeth;
  }
  
Graph testInput( ) {
  Graph design = new Graph( 5, 5 );
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

Graph testInput2( ) {
  Graph design = new Graph( 6, 6 );
  Node n1 = new Node( );
  n1.addEdge( s );
  n1.addEdge( sw );
  n1.addEdge( se );
  design.addNode( 3, 0, n1 );
  design.addNode( 3, 6, n1.nodeReflectY( ) );
  Node n2 = new Node( );
  n2.addEdge( ne );
  n2.addEdge( e );
  n2.addEdge( se );
  design.addNode( 0, 3, n2 );
  design.addNode( 6, 3, n2.nodeReflectX( ) );
  Node n3 = new Node( );
  n3.addEdge( ne );
  n3.addEdge( sw );
  design.addNode( 2, 1, n3 );
  design.addNode( 1, 2, n3 );
  design.addNode( 5, 4, n3 );
  design.addNode( 4, 5, n3 );
  design.addNode( 4, 1, n3.nodeReflectX( ) );
  design.addNode( 1, 4, n3.nodeReflectX( ) );
  design.addNode( 5, 2, n3.nodeReflectX( ) );
  design.addNode( 2, 5, n3.nodeReflectX( ) );
  Node n4 = new Node( );
  n4.addEdge( n );
  n4.addEdge( s );
  design.addNode( 3, 1, n4 );
  design.addNode( 3, 5, n4 );
  Node n4f = new Node( );
  n4f.addEdge( e );
  n4f.addEdge( w );
  design.addNode( 1, 3, n4f );
  design.addNode( 5, 3, n4f );
  Node n5 = new Node( );
  n5.addEdge( n );
  n5.addEdge( s );
  n5.addEdge( e );
  n5.addEdge( w );
  design.addNode( 2, 3, n5 );
  design.addNode( 4, 3, n5 );
  design.addNode( 3, 2, n5 );
  design.addNode( 3, 4, n5 );
  Node n6 = new Node( );
  n6.addEdge( n );
  n6.addEdge( s );
  n6.addEdge( e );
  n6.addEdge( w );
  n6.addEdge( ne );
  n6.addEdge( nw );
  n6.addEdge( se );
  n6.addEdge( sw );
  design.addNode( 3, 3, n6 );
  Node n7 = new Node( );
  n7.addEdge( s );
  n7.addEdge( e );
  n7.addEdge( se );
  design.addNode( 2, 2, n7 );
  design.addNode( 2, 4, n7.nodeReflectY( ) );
  design.addNode( 4, 2, n7.nodeReflectX( ) );
  design.addNode( 4, 4, n7.nodeReflectX( ).nodeReflectY( ) );
  
  
  
  return design;
}


Graph testInput3( ) {
  Graph design = new Graph( 6, 6 );
  Node n1 = new Node( );
  n1.addEdge( s );
  n1.addEdge( sw );
  n1.addEdge( se );
  n1.addEdge( w );
  n1.addEdge( e );
  n1.addEdge( ne );
  n1.addEdge( nw );
  
  Node n2 = new Node( );
  n2.addEdge( ne );
  n2.addEdge( e );
  n2.addEdge( se );
  //n2.addEdge( nw );
  //n2.addEdge( sw );
  n2.addEdge( n );
  n2.addEdge( s );
  
  Node n3 = new Node( );
  n3.addEdge( ne );
  n3.addEdge( sw );

  Node n4 = new Node( );
  n4.addEdge( n );
  n4.addEdge( s );
  design.addNode( 3, 1, n1 );
  design.addNode( 3, 5, n1.nodeReflectY( ) );
  Node n4f = new Node( );
  n4f.addEdge( e );
  n4f.addEdge( w );
  
  design.addNode( 2, 1, n4f );
  design.addNode( 1, 2, n4 );
  design.addNode( 5, 4, n4 );
  design.addNode( 4, 5, n4f );
  design.addNode( 4, 1, n4f );
  design.addNode( 1, 4, n4 );
  design.addNode( 5, 2, n4 );
  design.addNode( 2, 5, n4f );
  design.addNode( 1, 3, n2 );
  design.addNode( 5, 3, n2.nodeReflectX( ) );
  Node n5 = new Node( );
  n5.addEdge( n );
  n5.addEdge( s );
  n5.addEdge( e );
  n5.addEdge( w );
  design.addNode( 2, 3, n4f );
  design.addNode( 4, 3, n4f );
  design.addNode( 3, 2, n4 );
  design.addNode( 3, 4, n4 );
  Node n6 = new Node( );
  n6.addEdge( n );
  n6.addEdge( s );
  n6.addEdge( e );
  n6.addEdge( w );
  //n6.addEdge( ne );
  //n6.addEdge( nw );
  //n6.addEdge( se );
  //n6.addEdge( sw );
  design.addNode( 3, 3, n6 );
  Node n7 = new Node( );
  //n7.addEdge( se );
  n7.addEdge( ne );
  n7.addEdge( sw );
  n7.addEdge( nw );
  design.addNode( 2, 2, n7 );
  design.addNode( 2, 4, n7.nodeReflectY( ) );
  design.addNode( 4, 2, n7.nodeReflectX( ) );
  design.addNode( 4, 4, n7.nodeReflectX( ).nodeReflectY( ) );
  Node n8 = new Node( );
  n8.addEdge( nw );
  n8.addEdge( s );
  n8.addEdge( e );
  n8.addEdge( se );
  design.addNode( 1, 1, n8 );
  design.addNode( 1, 5, n8.nodeReflectY( ) );
  design.addNode( 5, 1, n8.nodeReflectX( ) );
  design.addNode( 5, 5, n8.nodeReflectX( ).nodeReflectY( ) );
  Node n9 = new Node( );
  //n9.addEdge( s );
  n9.addEdge( e );
  n9.addEdge( se );
  design.addNode( 0, 0, n9 );
  design.addNode( 0, 6, n9.nodeReflectY( ) );
  design.addNode( 6, 0, n9.nodeReflectX( ) );
  design.addNode( 6, 6, n9.nodeReflectX( ).nodeReflectY( ) );
  
  design.addNode( 1, 0, n4f );
  design.addNode( 5, 0, n4f );
  design.addNode( 1, 6, n4f );
  design.addNode( 5, 6, n4f );
  
  //design.addNode( 0, 1, n4 );
  //design.addNode( 0, 5, n4 );
  //design.addNode( 6, 1, n4 );
  //design.addNode( 6, 5, n4 );
  
  Node n10 = new Node( );
  n10.addEdge( w );
  n10.addEdge( se );
  design.addNode( 2, 0, n10 );
  design.addNode( 4, 0, n10.nodeReflectX( ) );
  design.addNode( 2, 6, n10.nodeReflectY( ) );
  design.addNode( 4, 6, n10.nodeReflectY( ).nodeReflectX( ) );
  
  Node n11 = new Node( );
  n11.addEdge( n );
  n11.addEdge( se );
  //design.addNode( 0, 2, n11 );
  //design.addNode( 0, 4, n11.nodeReflectY( ) );
  //design.addNode( 6, 2, n11.nodeReflectX( ) );
  //design.addNode( 6, 4, n11.nodeReflectY( ).nodeReflectX( ) );
  
  
  
  
  return design;
}

