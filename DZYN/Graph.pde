class Graph {
  private HashMap< Location, Node > grid;
  private int wide;
  private int high;
  Graph ( int x, int y ) {
    int wide = x;
    int high = y;
    grid = new HashMap< Location, Node > ( );
  }
  
  
  //first Node added sets the current to it's location for display testing purposes
  void addNode( int xloc, int yloc, Node n ) {
    Location l = new Location( xloc, yloc );
    grid.put( l, n );
  }

 
  Teeth extract( ) {
    Teeth teeth = new Teeth( );
    Set set = grid.keySet( );
    for ( Object o : set ) {
      Location loc = ( Location ) o;
      teeth.addTeeth( aldente( loc ) );
    }
    return teeth;
  }
  
  Teeth aldente( Location loc ) {
    Node node = grid.get( loc );
    Teeth teeth = new Teeth( );
    Location currentLoc = null;
    ArrayList< Edge > adjs = node.adjacents( );
    
    for ( Edge edge : adjs ) {
      Tooth tooth = new Tooth( );
      
      //add the points to the tooth
      for ( Edge e : adjs ) {
        if ( !e.equals( edge ) ) {
          Point p = new Point( e );
          tooth.addPoint( p );
        } 
      }

      tooth.expandCrown( edge );
      currentLoc = loc.trace( edge );
      node = grid.get( currentLoc );

      //in case of crown lines
      while( node.degree( ) <3 ) {
        if ( node.degree( ) == 0 || node.degree( ) == 1 ) break;
        edge = node.adjacents( ).get( 0 ).equals( edge ) ?
                    node.adjacents( ).get( 0 ) : node.adjacents( ).get( 1 );
        tooth.expandCrown( edge );
        currentLoc = currentLoc.trace( edge );
        node = grid.get( currentLoc );
      }
      teeth.addTeeth( roots( tooth, currentLoc, edge ) );
    }
    return teeth;
  }
  
  //all possible root systems sans where just came from ( edge )
  Teeth roots( Tooth tooth, Location loc, Edge edge ) {
    edge = edge.inverse( );
    Teeth teeth = new Teeth( );
    ArrayList< Edge > adjs = grid.get( loc ).adjacents( );
    int size = adjs.size( );
    for ( int i = 0; i < size; ++i )
      for ( int j = i + 1; j < size; ++j ) {
        Tooth t = new Tooth( tooth );
        Edge right = adjs.get( i );
        Edge left  = adjs.get( j );
        if ( !right.equals( edge ) && !left.equals( edge ) ) {
          t.forkRight( right );
          t.forkLeft( left );
          teeth.addTooth( t );
        }
      }
    return teeth;
  }

  void display( int scale, int xS, int yS ){
    Set set = grid.keySet( );
    for ( Object o : set ) {
      Location l = ( Location ) o;
      Node n = grid.get( l );
      float _x = xS + l.xloc( ) * scale;
      float _y = yS + l.yloc( ) * scale;
      for ( Edge e : n.adjacents( ) ) {
        float _xto = _x + e.x( )*scale/2.3;
        float _yto = _y + e.y( )*scale/2.3;
        line( _x, _y, _xto, _yto  );
      }
      strokeWeight( 1 );
      ellipse( _x, _y, 8,8 );
      strokeWeight( 2 );
    }
  }
  String toString( ) {
    String s = "[ ";
    Set set = grid.keySet( );
    for ( Object o : set ) {
      Location l = ( Location ) o;
      Node n = grid.get( l );
      s += n + ", ";
    }
    s += " ]";
    return s;
  }
  final HashMap< Location, Node > grid( ) { return grid; }
}

class Location {

  int x;
  int y;
  
  Location( ) { }
  Location( int _x, int _y ) { x = _x; y = _y; }
  Location( Location l ) {
    x = xloc( );
    y = yloc( );
  }
  
  void xloc( int _x ) { x = _x; }
  void yloc( int _y ) { y = _y; }
  
  final int xloc( ) { return x; }
  final int yloc( ) { return y; }
  
  Location trace ( Edge e ) {
    return new Location( xloc( ) + e.x( ), yloc( ) + e.y( ) );
  }
  
  public boolean equals( Object obj ){
    if ( obj == this ) return true;    
    if ( obj == null || obj.getClass( ) != getClass( ) ) return false;    
    Location l = ( Location ) obj;
    return xloc( ) == l.xloc( ) && yloc( ) == l.yloc( );
  }
  
  public int hashCode( ) { return x * 10 + y; }
  
  String toString( ) {
    String s = "( " + x + ", " + y + " )\n";
    return s;
  }

}



