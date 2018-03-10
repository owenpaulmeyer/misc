class GGraph {
  HashMap< Location, GNode > grid;
  int wide;
  int high;
  
  GGraph ( ) {
    grid = new HashMap< Location, GNode > ( );
    wide = 0;
    high = 0;
  }
  
  GGraph ( int x, int y ) {
    wide = x;
    high = y;
    grid = new HashMap< Location, GNode > ( );
    initialize( );
  }
  
  void addNode( int xloc, int yloc, GNode n ) {
    Location l = new Location( xloc, yloc );
    grid.put( l, n );
  }

  //all locations start out with empty ratios
  void initialize( ) {
    for ( int x = 0; x < wide; ++x )
      for ( int y = 0; y < high; ++y ) {
        addNode( x, y, new GNode( ) );
      }
  }

  //the weight of the other side of the edge @ param edge
  Ratio returnWeight( Location loc, Edge edge ) {
    Location l = trace( loc, edge );
    GNode next = grid.get( l );
    return next.edgeWeight( edge.inverse( ) );
  }

  //moves about the toroidal grid
  //Location::trace returns a new location
  Location trace ( Location loc, Edge e ) {
    Location l = loc.trace( e );
    if ( l.xloc( ) < 0 ) l.xloc( wide-1 );
    if ( l.xloc( ) == wide ) l.xloc( 0 );
    if ( l.yloc( ) < 0 ) l.yloc( high-1 );
    if ( l.yloc( ) == high ) l.yloc( 0 );
    return l;
  }

  //genesis
  void setSeed ( Seed seed, Location loc ) {
    GNode node = grid.get( loc );
    for ( WeightedEdge edge : seed ) {
      node.balance( edge, 1.0 );
      Location l = trace( loc, edge );
      GNode opNode = grid.get( l );
      Edge opEdge  = edge.inverse( );
      opNode.balance ( new WeightedEdge( opEdge, edge.weight( ) ), 1.0 ); 
    } 
  }

  //balances a valalnce into the grid
  void setBuffer( Pair < Setting, Location > pair ) {
    setSetting( pair.fst( ), pair.snd( ) );
  }

  //used by setBuffer
  void setSetting ( Setting set, Location loc ) {
    GNode node = grid.get( loc );
    for ( WeightedEdge edge : set ) {
      node.balance( edge, 1.0 );
      Location l = trace( loc, edge );
      GNode oppositeNode = grid.get( l );
      Edge oppositeEdge  = edge.inverse( );
      oppositeNode.balance ( new WeightedEdge( oppositeEdge, edge.weight( ) ), 1.0 ); 
    } 
  }
  
  void decide ( Location loc ) {
    GNode node = grid.get( loc );
    double threshold = threshold( );
    for ( Edge edge : directions( ) ) {
      double weight = node.edgeWeight( edge ).eval( );
      if ( weight > threshold ) {
        println( "weight: " + weight );
        Ratio w = new Ratio( 1, 1 );
        node.setWeight( edge, w );
        setOpposite( loc, edge, w );
      }
      else {
        println( "weight: " + weight );
        Ratio w = new Ratio ( 0, 0 ) ;
        node.setWeight( edge, w );
        setOpposite( loc, edge, w );
      }
    }
  }
  
  void setOpposite( Location loc, Edge edge, Ratio weight ) {
    Location l = trace( loc, edge );
    GNode oppositeNode = grid.get( l );
    Edge oppositeEdge = edge.inverse( );
    oppositeNode.setWeight( oppositeEdge, weight );
  }

  //for setting aside the results of setting a set of teeth per location
  //to be balanced into the grid on a per valence schedule
  Pair< Setting, Location > bufferTeeth( Teeth teeth, Location loc ) {
    Setting set = new Setting( );
    for ( Tooth tooth : teeth )
      set = setTooth( tooth, loc, set );
    return new Pair< Setting, Location > ( set, loc );
  }

  //produces a set of weighted edges corresponding to the scaled 
  //Ratios of the points of the fitted tooth
    //point setting must be separated into the two for loops so that 
    //empty points get the ratio denominator factored in as well as
    //the not empty points (which would be the case in combining the
    //two for loops.
  Setting setTooth( Tooth tooth, Location loc, Setting set ) {
    double scale = fitTooth( tooth, loc );
    ArrayList< Point > points = tooth.points( );
    for ( Point p : points ) {
      WeightedEdge we = new WeightedEdge( p.edge( ), tooth.pointWeight( p ) );
      set.balance( we, scale );
    }
    Edge from = tooth.crown( ).get( 0 );
    ArrayList< Edge > directions = directions( );
    directions.remove( from );  //can't balance the direction the tooth 'looks'
    for ( Edge edge : directions ) {
      WeightedEdge we = new WeightedEdge( edge , tooth.toothWeight( ) );
      set.balance( we, scale );
    }
    //if ( scale != 0 ) {
    //if ( loc.equals( new Location( 0, 1 ) ) ){
    //println( "location: " + loc );
    //println( "Scalar: " + scale );
    //println( "TOOTH: " + tooth );
    //println( "GNODE: " + node );
    //}
    return set;
  }
  
  //determines the weight of tooth's fit @ loc
  double fitTooth( Tooth tooth, Location loc ) {
    double weight = 1.0;
    GNode currentNode = grid.get( loc );
    for ( int i = 0; i < tooth.crown( ).size( ); ++i ) {
      Edge edge = tooth.crown( ).get( i );
      double w1 = currentNode.edgeWeight( edge ).eval( );
      double w2 = returnWeight( loc, edge ).eval( );
      //weight *= ( w1 + w2 ) / 2;
      //if ( loc.equals( new Location( 0, 1 ) ) ) println( w2 );
      weight *= w2;
      loc = trace( loc, edge );
      currentNode = grid.get( loc );
      //if ( loc.equals( new Location( 0, 1 ) ) ) {
      //  println( w1 );
      //  println( w2 );
      //  println( weight );
      //}
    }
    double left =  currentNode.edgeWeight( tooth.root( ).left( )  ).eval( );
    double right = currentNode.edgeWeight( tooth.root( ).right( ) ).eval( );
    return weight * left * right;
  }

  String toString( ) {
    String s = "";
    Set keys = grid.keySet( );
    for ( Object o : keys ) {
      Location loc = ( Location ) o;
      GNode node = grid.get( loc );
      s += "Location:  " + loc;
      s += node + "\n";
    }
    return s;
  }

  void display( int scale, int xS, int yS ){
    float sW = .09 * scale;
    strokeWeight( sW );
    Set set = grid.keySet( );
    for ( Object o : set ) {
      Location l = ( Location ) o;
      GNode n = grid.get( l );
      float _x = xS + l.xloc( ) * scale;
      float _y = yS + l.yloc( ) * scale;
      for ( Edge e : directions( ) ) {
        float _xto = _x + e.x( )*scale/2;
        float _yto = _y + e.y( )*scale/2;
        double weight = n.edgeWeight( e ).eval( );
        int alpha = (int)(255 * weight);
        stroke( 0, 0, 0, alpha );
        line( _x, _y, _xto, _yto  );
      }
      /*
      strokeWeight( 1.5 );
      stroke( 0, 0 , 0 );
      ellipse( _x, _y, .2 * scale, .2 * scale );
      strokeWeight( sW );
      */
    }
  }
  
}


