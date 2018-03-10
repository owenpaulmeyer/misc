
class Tooth {
  private Line crown = new Line( );
  private Fork root = new Fork( );
  private Points points = new Points( );
  private int count = 1;
  
  Tooth ( ) { }
  
  Tooth ( Tooth t ) {
    for ( Point p : t.points( ) )
      points.add( new Point( p.fst( ), p.snd( ) ) );
    for ( Edge e : t.crown ) {
      crown.add( e );
    }
    root.fst( t.root.fst() );
    root.snd( t.root.snd() );
    count = t.count;
  }
 
  Tooth copy (  ) {
    Tooth tooth = new Tooth( );
    for ( Edge e : crown ) {
      tooth.expandCrown( e );
    }
    tooth.forkRight( root.fst() );
    tooth.forkLeft( root.snd() );
    return tooth;
  }

  //stand in to test
  public boolean equals( Object obj ){
    if ( obj == this ) return true;    
    if ( obj == null || obj.getClass( ) != getClass( ) ) return false;    
    Tooth t = ( Tooth ) obj;
    return crown.equals( t.crown ) && root.equals( t.root );
  }
  
  void expandCrown( Edge e ) { crown.add( e ); }
  
  void forkRight( Edge e ) { root.fst( e ); }
  void forkLeft ( Edge e ) { root.snd( e ); }
  /*
  void addPoint( Edge e ) {
    Point p = new Point( e, 1 );
    if ( points.contains( p ) ) {
      points.get( points.indexOf( p ) ).incrementCount( );
    }
    else points.add( new Point( e, 1 ) );
  }
  */
  void addPoint( Point p ) {
    
    if ( points.contains( p ) ) {
      Point point = points.get( points.indexOf( p ) );
      if ( p.count( ) == 1 ) point.incrementCount( );
      else point.decrementCount( );
    }
    else {
        Point p2 = new Point( p.edge( ), p.count( ) );//here's where the negative point bug was!
        points.add( p2 );
    }
  }
  
  void addPoints( Points ps ) {
    for ( Point p : ps ) addPoint( p );
  }
  
/*
  void addPoints( Points ps ) {
    ArrayList< Edge > dirs = directions( );
    for ( Edge e : dirs ) {
      Point p = new Point( e );
      if ( ps.contains( p ) ) addPoint( p );
      else subPoint( p );
    }
  }
  */
  void subPoint( Point p ) {
    if ( points.contains( p ) ) {
      points.get( points.indexOf( p ) ).decrementCount( );
    }
    else {
      Point p2 = new Point( p.edge( ), -1 );
      points.add( p2 );
    }
  }
  
  void incrementCount( ) { ++count; }
  
  Ratio pointWeight( Point p ) {
    return new Ratio ( p.count( ), 0 );
  }
  
  Ratio toothWeight( ) { return new Ratio ( 0, count( ) ); }

  
  final Line crown   ( ) { return crown; }
  final Fork root    ( ) { return root; }
  final Points points( ) { return points; }
  final int count    ( ) { return count; }
  
  
  JSONObject toJSON( ) {
    JSONObject jsn = new JSONObject( );
    jsn.setJSONObject( "points", points.toJSON( ) );
    jsn.setJSONObject( "crown", crown.toJSON( ) );
    jsn.setJSONObject( "root", root.toJSON( ) );
    jsn.setInt( "count", count );
    return jsn;
 }
  
  String toString( ) {
    String s = "\n  Points: "+points+"\n  Crown:  "+
      crown+"\n  Root:   "+root+"\n  Count:  "+count+"\n";
    return s;
  }
  
  //superflous
  void display( ) {
    //println( "Tooth:" );
    println( "  Points:" );
    println( "    " + points );
    println( "  Crown:" );
    println( "    " + crown );
    println( "  Root:" );
    println( "    " + root );
    println( "  Count:  " + count );
  }
}

