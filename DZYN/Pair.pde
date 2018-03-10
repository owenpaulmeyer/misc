class Pair < T1, T2 > {
  private T1 fst;
  private T2 snd;
  
  Pair ( ) {}
  
  Pair ( T1 t1, T2 t2 ) { fst = t1; snd = t2; }
  
  final T1 fst( ) { return fst; }
  
  final T2 snd( ) { return snd; }
  
  void fst( T1 o ) { fst = o; }
  
  void snd( T2 o ) { snd = o; }
  
  String toString( ) {
    String s = "( " + fst( ).toString( ) + ", " + snd( ).toString( ) + " )";
    return s;
  }

}

class Ratio {
  private double num;
  private double den;
  
  Ratio ( double _num, double _den ) { num = _num; den = _den; }
  
  final double numerator( ) { return num; }
  final double denominator( ) { return den; }
  
  void balance( Ratio r ) {
    num += r.numerator( );
    den += r.denominator( );
  }
  
  void scaleRatio( double scale ) {
    num *= scale;
    den *= scale;
  }

  double eval( ) {
    if ( den == 0 ) return 0;
    return num / den;
  }
  
  String toString( ) {
    String s = "";
    s += num + " / ";
    s += den;
    return s;
  }
 
}
