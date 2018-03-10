float a1 = .182574186;
float b1 = .365148372;
float c1 = .547722558;
float d1 = .730296744;
float a2 = .480384462;
float b2 = .320256308;
float c2 = .160128154;
float d2 = .80064077;

float a3 = a1*a2-b1*b2-c1*c2-d1*d2;
float b3 = a1*b2+b1*a2+c1*d2-d1*c2;
float c3 = a1*c2-b1*d2+c1*a2+d1*b2;
float d3 = a1*d2+b1*c2-c1*b2+d1*a2;

println("a3 = " + a3 );
println("b3 = " + b3 );
println("c3 = " + c3 );
println("d3 = " + d3 );
println("result:  " + sqrt( a3*a3+b3*b3+c3*c3+d3*d3 ));
