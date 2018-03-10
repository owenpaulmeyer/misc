class Teeth extends ArrayList< Tooth > {
  void addTooth( Tooth tooth ) {
    if ( contains( tooth ) ) { //println( "Contains: " + contains( tooth ) );
      Tooth t = get( indexOf( tooth ) );
      t.addPoints( tooth.points( ) );
      t.incrementCount( );
    }
    else add( tooth );
  }
  void addTeeth( Teeth teeth ) {
    for ( Tooth t : teeth )
      this.addTooth( t );
  }
}



//Sequentially equated
class Line extends ArrayList< Edge > {
  
  public boolean equals( Object obj ){
    if ( obj == this ) return true;    
    if ( obj == null || obj.getClass( ) != getClass( ) ) return false;    
    Line line = ( Line ) obj;    
    Iterator< Edge > itr_this = iterator( );
    Iterator< Edge > itr_line = line.iterator( );
    if ( size( ) != line.size( ) ) return false;
    while ( itr_this.hasNext( ) && itr_line.hasNext( ) ) {
      if ( ! itr_this.next( ).equals( itr_line.next( ) ) ) return false;
    }
    return true;
  }
  
  JSONObject toJSON( ) {
    JSONObject jsn = new JSONObject( );
    JSONArray line = new JSONArray( );
    for ( int i = 0; i < this.size( ); ++i ) {
      JSONObject edge = this.get( i ).toJSON( );
      line.setJSONObject( i, edge );
    }
    jsn.setJSONArray( "line", line );
    return jsn;
 }
}

class Fork extends Pair< Edge, Edge > {
  
  //accounts for swapped order
  public boolean equals( Object obj ){
    if ( obj == this ) return true;    
    if ( obj == null || obj.getClass( ) != getClass( ) ) return false;    
    Fork f = ( Fork ) obj;    
    if ( f.fst().equals( fst() ) ) return f.snd().equals( snd() );    
    else if ( f.fst().equals( snd() ) ) return f.snd().equals( fst() );    
    else return false;
  }
  
  Edge right( ) { return fst( ); }
  Edge left( )  { return snd( ); }
  
  JSONObject toJSON( ) {
    JSONObject jsn = new JSONObject( );
    jsn.setJSONObject( "right", fst( ).toJSON( ) );
    jsn.setJSONObject( "left", snd( ).toJSON( ) );
    return jsn;
 }
}

class Point extends Pair< Edge, Integer >{
  
  Point ( Edge e ) {
    fst( e );
    snd( 1 );
  }
  
  Point ( Edge e, Integer i ) {
    fst( e );
    snd( i );
  }
  
  final Edge edge ( ) { return fst( ); }
  final int  count( ) { return snd( ); }
  
  public boolean equals( Object obj ){
    if ( obj == this ) return true;
    if ( obj == null || obj.getClass( ) != getClass( ) ) return false;
    Point p = ( Point ) obj;
    return p.edge( ).equals( edge( ) );
  }

  void incrementCount( ) { snd( count( ) + 1 ); }
  
  JSONObject toJSON( ) {
    JSONObject jsn = new JSONObject( );
    jsn.setJSONObject( "point", fst( ).toJSON( ) );
    jsn.setInt( "count", snd( ) );
    return jsn;
 }
  
  String toString( ) {
    String s = "( " + edge( ).toString( ) + ", Count: " + count( ) + " )";
    return s;
  }
}

class Points extends ArrayList< Point > {
  
  public boolean equals( Object obj ){
    if ( obj == this ) return true;
    if ( obj == null || obj.getClass( ) != getClass( ) ) return false;
    Points ps = ( Points ) obj;
    Iterator< Point > itr = iterator( );
    while ( itr.hasNext( ) ) {
      if ( !ps.contains( itr.next( ) ) ) return false;
    }
    return true;
  }
  
  JSONObject toJSON( ) {
    JSONObject jsn = new JSONObject( );
    JSONArray points = new JSONArray( );
    for ( int i = 0; i < this.size( ); ++i ) {
      JSONObject point = this.get( i ).toJSON( );
      points.setJSONObject( i, point );
    }
    jsn.setJSONArray( "points", points );
    return jsn;
 }
  
}



