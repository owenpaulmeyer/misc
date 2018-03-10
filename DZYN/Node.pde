class Node {

  private ArrayList< Edge > adjacents;
  
  Node (  ) { adjacents = new ArrayList< Edge >( ); }
  
  Node ( ArrayList< Edge > adj ) {
    adjacents = adj;
  }
  
  Node ( Node n ) {
    adjacents = new ArrayList< Edge > ( );
    for ( Edge e : n.adjacents( ) )
      adjacents.add( e );
  }
  
  void addEdge( Edge adj ) { adjacents.add( adj ); }
  
  final ArrayList< Edge > adjacents( ) { return adjacents; }
  final int degree   ( ) { return adjacents.size( ); }
  
  //for assisting graph inputting
  Node nodeReflectX( ) {
    ArrayList< Edge > adj = new ArrayList< Edge >( );
    for ( Edge e : adjacents( ) ) {
      adj.add( reflectX( e ) );
    }
    return new Node( adj );
  }
  //for assisting graph inputting
  Node nodeReflectY( ) {
    ArrayList< Edge > adj = new ArrayList< Edge >( );
    for ( Edge e : adjacents( ) ) {
      adj.add( reflectY( e ) );
    }
    return new Node( adj );
  }
  
  String toString( ) {
    String s = "";
    for ( Edge e : adjacents ) s += " " + e;
    return s;
  }
}

class GNode {
  //NodeWeight usage is unknown at this point
  private double weight = 1.0;
  private State state = State.Open;
  private Ratio north     = new Ratio( 0, 0 );
  private Ratio south     = new Ratio( 0, 0 );
  private Ratio east      = new Ratio( 0, 0 );
  private Ratio west      = new Ratio( 0, 0 );
  private Ratio northeast = new Ratio( 0, 0 );
  private Ratio northwest = new Ratio( 0, 0 );
  private Ratio southeast = new Ratio( 0, 0 );
  private Ratio southwest = new Ratio( 0, 0 );

  GNode( ) { }

  GNode( GNode gn ) {
    weight = gn.weight;
    north  = gn.north;
    south  = gn.south;
    east   = gn.east;
    west   = gn.west;
    northeast = gn.northeast;
    northwest = gn.northwest;
    southeast = gn.southeast;
    southwest = gn.southwest;
  }

  //balances by the WeightedEdge
  void balance ( WeightedEdge edge, double scale ) {
    Edge e = edge.direction( );
    Ratio w = edge.weight( );
    w.scaleRatio( scale );
    if     ( e.isNorth()  ) north.balance( w );
    else if( e.isSouth()  ) south.balance( w );
    else if( e.isWest()   ) west.balance( w );
    else if( e.isEast()   ) east.balance( w );
    else if( e.isNorthW() ) northwest.balance( w );
    else if( e.isNorthE() ) northeast.balance( w );
    else if( e.isSouthW() ) southwest.balance( w );
    else if( e.isSouthE() ) southeast.balance( w );
  }

  void setWeight ( Edge e, Ratio w ) {
    if     ( e.isNorth()  ) north = w;
    else if( e.isSouth()  ) south = w;
    else if( e.isWest()   ) west = w;
    else if( e.isEast()   ) east = w;
    else if( e.isNorthW() ) northwest = w;
    else if( e.isNorthE() ) northeast = w;
    else if( e.isSouthW() ) southwest = w;
    else if( e.isSouthE() ) southeast = w;
  }

  Ratio edgeWeight( Edge e ) {
    if     ( e.isNorth()  ) return north;
    else if( e.isSouth()  ) return south;
    else if( e.isWest()   ) return west;
    else if( e.isEast()   ) return east;
    else if( e.isNorthW() ) return northwest;
    else if( e.isNorthE() ) return northeast;
    else if( e.isSouthW() ) return southwest;
    else if( e.isSouthE() ) return southeast;
    else return new Ratio( 0, 0 );
  }

  void closeState( ) { state = State.Closed; }
  void openState ( ) { state = State.Open; }
  
  final double nodeWeight( ) { return weight; }
  
  String toString( ) {
    String s = "\n";
    s += "  N:   " + north + "\n";
    s += "  S:   " + south + "\n";
    s += "  W:   " + west + "\n";
    s += "  E:   " + east + "\n";
    s += "  NW:  " + northwest + "\n";
    s += "  NE:  " + northeast + "\n";
    s += "  SW:  " + southwest + "\n";
    s += "  SE:  " + southeast + "\n";
    return s;
  }
}

class Seed extends ArrayList< WeightedEdge >{
}
class Setting extends ArrayList< WeightedEdge > {
  
  Setting ( ) {
    super( );
    initialize( );
  }
  
  void initialize( ) {
    for ( Edge e : directions( ) ) {
      add( new WeightedEdge( e, new Ratio( 0, 0 ) ) );
    }
  }

  void balance ( WeightedEdge edge, double scale ) {
    Edge e = edge.direction( ); //balance Setting @ e...
    Ratio w = edge.weight( );
    w.scaleRatio( scale ); //...with the weight 'w' scaled as such
    int idx = indexOf( edge );
    WeightedEdge we = get( idx );
    we.balance( w );
  }
}

  
