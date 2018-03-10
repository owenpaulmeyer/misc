//Directional Edge
class Edge {
  
  private int x;
  private int y;

  Edge (int _x, int _y){
    x = _x;
    y = _y;
  }
  
  final int x(){return x;}
  final int y(){return y;}
  
  Edge inverse() {
    return new Edge( x * -1, y * -1 );
  }
  
  public boolean equals( Object obj ){
    if ( obj == this ) return true;
    if ( obj == null || obj.getClass( ) != getClass( ) ) return false;
    Edge e = ( Edge ) obj;
    return this.x==e.x() && this.y==e.y();
  }
  
  boolean isNorth(){
    return (x==0 && y==-1);
  }
  boolean isSouth(){
    return (x==0 && y==1);
  }
  boolean isWest(){
    return (x==-1 && y==0);
  }
  boolean isEast(){
    return (x==1 && y==0);
  }
  boolean isNorthW(){
    return (x==-1 && y==-1);
  }
  boolean isNorthE(){
    return (x==1 && y==-1);
  }
  boolean isSouthW(){
    return (x==-1 && y==1);
  }
  boolean isSouthE(){
    return (x==1 && y==1);
  }
  
  JSONObject toJSON( ) {
    JSONObject jsn = new JSONObject( );
    jsn.setInt( "x", x( ) );
    jsn.setInt( "y", y( ) );
    return jsn;
 }
  
  String toString() {
    if( isNorth() ) return "N";
    else if( isSouth() ) return "S";
    else if( isWest() ) return "W";
    else if( isEast() ) return "E";
    else if( isNorthW() ) return "NW";
    else if( isNorthE() ) return "NE";
    else if( isSouthW() ) return "SW";
    else if( isSouthE() ) return "SE";
    else return "zero";
  }
}

boolean isNull( Object a ) {
  return (a == null);
}

class WeightedEdge extends Edge {
  Ratio weight = new Ratio ( 0, 0 );
  
  WeightedEdge( Edge e ) { super( e.x( ), e.y( ) ); }

  WeightedEdge( Edge e, Ratio w ) {
    super( e.x( ), e.y( ) );
    weight = w;
  }
  
  void balance( Ratio scaledRatio ) {
    weight.balance( scaledRatio );
  }
  
  final Ratio weight( )   { return weight; }
  final Edge direction( ) { return ( Edge ) this; }
  
  public boolean equals( Object obj ){
    if ( obj == this ) return true;
    if ( obj == null || obj.getClass( ) != getClass( ) ) return false;
    WeightedEdge e = ( WeightedEdge ) obj;
    return super.x==e.x() && super.y==e.y();
  }
  
  String toString( ) {
    String s = "( ";
    s += super.toString( ) + ", ";
    s += weight.toString( ) + " )";
    return s;
  }
}



