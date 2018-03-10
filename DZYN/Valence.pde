class Valence {
  ArrayList< Location > current  = new ArrayList< Location > ( );
  ArrayList< Location > previous = new ArrayList< Location > ( );
  ArrayList< Location > seeds    = new ArrayList< Location > ( );
  int wide;
  int high;

  ArrayList< Location > current( ) { return current; }
  ArrayList< Location > previous( ) { return previous; }

  Valence( int w, int h ) {
    wide = w;
    high = h;
  }
  
  Valence( ) {
    wide = 0;
    high = 0;
  }

  void seed( Location loc ) {
    seeds.add( loc );
    current.add( loc );
  }

  void next( ) {
    ArrayList< Location > next = new ArrayList< Location > ( );
    for ( Location l : current )
      for ( Edge e : directions( ) ) {
        Location loc = trace( l, e );
        if ( !current.contains( loc ) && 
            !previous.contains( loc ) &&
            !next.contains( loc ) ) next.add( loc );
      }

    previous.addAll( current );
    current = next;
  }

  Location trace ( Location loc, Edge e ) {
    Location l = loc.trace( e );
    if ( l.xloc( ) < 0 ) l.xloc( wide-1 );
    if ( l.xloc( ) == wide ) l.xloc( 0 );
    if ( l.yloc( ) < 0 ) l.yloc( high-1 );
    if ( l.yloc( ) == high ) l.yloc( 0 );
    return l;
  }
  
}
