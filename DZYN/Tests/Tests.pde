void setup ( ) {
  size( 800, 800 );
  background ( 255, 255, 255 );
  smooth( );
  strokeWeight( 4 );
  strokeCap( SQUARE );
/*
  //Generic Pair Test:
  Pair < Integer, Integer > p1 = new Pair < Integer, Integer > ( 1 , 2 );
  println ( p1.fst );
  println ( p1.snd );
  Pair < Integer, Integer > p2 = new Pair < Integer, Integer > ( );
*/
  
/*  
  //Tooth constructing, copying, mutating Tests
  Tooth t1 = new Tooth ( );
  t1.addPoint( nw );
  t1.addPoint( se );
  t1.addPoint( w );
  t1.expandCrown( s );
  t1.forkRight( s );
  t1.forkLeft( sw );
  Tooth t2 = new Tooth ( t1 );
  t1.addPoint( w );
  t2.addPoint( nw );
  print( "Tooth2:" );
  println( t2 );
  print( "Tooth1:" );
  println( t1 );
*/

/*
  //Teeth Test
  Teeth teeth = new Teeth ( ) ;
  Tooth t1 = new Tooth( );
  t1.addPoint( nw );
  t1.addPoint( se );
  t1.addPoint( w );
  t1.expandCrown( s );
  t1.forkRight( s );
  t1.forkLeft( sw );
  Tooth t2 = new Tooth( );
  t2.addPoint( n );
  t2.addPoint( sw );
  t2.addPoint( e );
  t2.expandCrown( sw );
  t2.forkRight( s );
  t2.forkLeft( sw );
  teeth.addTooth( t1 );
  teeth.addTooth( t2 );
  println( "Teeth:" );
  println( teeth );
  Tooth t3 = new Tooth( t1 );
  Tooth t4 = new Tooth( t2 );
  t3.addPoint( nw );
  t4.addPoint( ne );
  teeth.addTooth( t3 );
  teeth.addTooth( t4 );
  t4.expandCrown( s );

  teeth.addTooth( t4 );
  println( "Teeth:" );
  println( teeth );
*/

/*
  //JSON Test
  Tooth tooth = new Tooth( );
  tooth.addPoint( nw );
  tooth.addPoint( s );
  tooth.expandCrown( e );
  tooth.forkRight( se );
  tooth.forkLeft( e );
  JSONObject jsn = tooth.toJSON( );
  print( jsn );
*/

/*
  //Graph Tests
  Graph design = testInput( );
  design.display( 20, 30, 30 );
  
  Teeth teeth = design.extract( );
  println( teeth );
*/

/*
  Teeth teeth2 = design.aldente( new Location ( 1, 4 ) );
  println( "2: " + teeth2.size( ) + teeth2 );
  Tooth th = new Tooth( );
  th.addPoint( nw );
  th.addPoint( se );
  th.addPoint( w );
  th.expandCrown( n );
  th.forkRight( sw );
  th.forkLeft( ne );
  teeth2.addTooth( th );
  println( "2: " + teeth2.size( ) + teeth2 );
*/


/*
  GGraph graph = new GGraph ( 5, 5 );
  Graph input = testInput( );
  Teeth teeth = input.extract( );
  Ratio weight = new Ratio( 1, 1 );
  
  Seed seed = new Seed( );
  
  seed.add( new WeightedEdge( n, weight ) );
  seed.add( new WeightedEdge( s, weight ) );
  seed.add( new WeightedEdge( w, weight ) );
  seed.add( new WeightedEdge( e, weight ) );
  seed.add( new WeightedEdge( nw, weight ) );
  seed.add( new WeightedEdge( ne, weight ) );
  seed.add( new WeightedEdge( sw, weight ) );
  seed.add( new WeightedEdge( se, weight ) );
  
  graph.setSeed( seed, new Location( 2, 2 ) );
  
  Tooth th = new Tooth( );
  th.addPoint( nw );
  th.addPoint( se );
  th.addPoint( w );
  th.expandCrown( s );
  th.forkRight( e );
  th.forkLeft( w );
  println( "Setting: " + graph.setTooth( th, new Location ( 2, 1 ), new Setting( ) ) );
  GNode gnode = new GNode( );

  Pair < Setting, Location > pair1 = graph.bufferTeeth( teeth, new Location ( 1, 1 ) );//println( pair1.fst( ) );
  Pair < Setting, Location > pair2 = graph.bufferTeeth( teeth, new Location ( 1, 2 ) );
  Pair < Setting, Location > pair3 = graph.bufferTeeth( teeth, new Location ( 1, 3 ) );
  Pair < Setting, Location > pair4 = graph.bufferTeeth( teeth, new Location ( 3, 1 ) );
  Pair < Setting, Location > pair5 = graph.bufferTeeth( teeth, new Location ( 3, 2 ) );
  Pair < Setting, Location > pair6 = graph.bufferTeeth( teeth, new Location ( 3, 3 ) );
  Pair < Setting, Location > pair7 = graph.bufferTeeth( teeth, new Location ( 2, 1 ) );
  Pair < Setting, Location > pair8 = graph.bufferTeeth( teeth, new Location ( 2, 3 ) );

  graph.setBuffer( pair1 );
  graph.setBuffer( pair2 );
  graph.setBuffer( pair3 );
  graph.setBuffer( pair4 );
  graph.setBuffer( pair5 );
  graph.setBuffer( pair6 );
  graph.setBuffer( pair7 );
  graph.setBuffer( pair8 );

  Pair < Setting, Location > pair21 = graph.bufferTeeth( teeth, new Location ( 0, 1 ) );
  Pair < Setting, Location > pair41 = graph.bufferTeeth( teeth, new Location ( 0, 3 ) );
  Pair < Setting, Location > pair71 = graph.bufferTeeth( teeth, new Location ( 4, 1 ) );
  Pair < Setting, Location > pair12 = graph.bufferTeeth( teeth, new Location ( 4, 3 ) );
  Pair < Setting, Location > pair42 = graph.bufferTeeth( teeth, new Location ( 3, 0 ) );
  Pair < Setting, Location > pair52 = graph.bufferTeeth( teeth, new Location ( 1, 0 ) );
  Pair < Setting, Location > pair72 = graph.bufferTeeth( teeth, new Location ( 3, 4 ) );
  Pair < Setting, Location > pair82 = graph.bufferTeeth( teeth, new Location ( 1, 4 ) );

  
  Pair < Setting, Location > pair11 = graph.bufferTeeth( teeth, new Location ( 0, 0 ) );
  Pair < Setting, Location > pair22 = graph.bufferTeeth( teeth, new Location ( 4, 4 ) );
  Pair < Setting, Location > pair61 = graph.bufferTeeth( teeth, new Location ( 4, 0 ) );
  Pair < Setting, Location > pair51 = graph.bufferTeeth( teeth, new Location ( 0, 4 ) );

  Pair < Setting, Location > pair31 = graph.bufferTeeth( teeth, new Location ( 0, 2 ) );
  Pair < Setting, Location > pair32 = graph.bufferTeeth( teeth, new Location ( 2, 0 ) );
  Pair < Setting, Location > pair81 = graph.bufferTeeth( teeth, new Location ( 4, 2 ) );
  Pair < Setting, Location > pair62 = graph.bufferTeeth( teeth, new Location ( 2, 4 ) );

  graph.setBuffer( pair31 );
  graph.setBuffer( pair32 );
  graph.setBuffer( pair81 );
  graph.setBuffer( pair62 );

  graph.setBuffer( pair21 );
  graph.setBuffer( pair41 );
  graph.setBuffer( pair71 );
  graph.setBuffer( pair12 );
  graph.setBuffer( pair42 );
  graph.setBuffer( pair52 );
  graph.setBuffer( pair72 );
  graph.setBuffer( pair82 );

  graph.setBuffer( pair11 );
  graph.setBuffer( pair22 );
  graph.setBuffer( pair61 );
  graph.setBuffer( pair51 );


  graph.display( 60, 60, 60 );
  save( "test.jpg" );
*/

  GGraph grid = new GGraph( 22, 22 );
  Graph input = testInput( );
  Teeth teeth = input.extract( );
  Ratio weight = new Ratio( 1, 1 );
  
  Seed seed = new Seed( );
  
  seed.add( new WeightedEdge( n, weight ) );
  seed.add( new WeightedEdge( s, weight ) );
  seed.add( new WeightedEdge( w, weight ) );
  seed.add( new WeightedEdge( e, weight ) );
  seed.add( new WeightedEdge( nw, weight ) );
  seed.add( new WeightedEdge( ne, weight ) );
  seed.add( new WeightedEdge( sw, weight ) );
  seed.add( new WeightedEdge( se, weight ) );
  
  grid.setSeed( seed, new Location( 5, 5 ) );
  grid.setSeed( seed, new Location( 16, 5 ) );
  grid.setSeed( seed, new Location( 5, 16 ) );
  grid.setSeed( seed, new Location( 16, 16 ) );
  
  Valence vale = new Valence( 22, 22 );
  vale.seed( new Location( 5, 5 ) );
  vale.seed( new Location( 16, 5 ) );
  vale.seed( new Location( 5, 16 ) );
  vale.seed( new Location( 16, 16 ) );
  
  vale.next( );


for ( int i = 0; i < 5; ++i ) {
  //println( "cur: " +vale.current( ) );
  //println( "prev: " + vale.previous( ) );
  ArrayList< Pair < Setting, Location > > buffer =
    new ArrayList< Pair < Setting, Location > > ( );
  for ( Location loc : vale.current( ) ) {
    Pair < Setting, Location > pair = grid.bufferTeeth( teeth, loc );
    buffer.add( pair );
  }
  for ( Pair< Setting, Location > p : buffer ) {
    grid.setBuffer( p );
  }
  for ( Location loc : vale.current( ) ) {
    grid.decide( loc );
  }
  vale.next( );
}
  
  grid.display( 20, 20, 20 );
  
  save( "result.jpg" );

}



