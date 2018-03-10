class Complex{
  float re;
  float im;

  Complex(float r_x, float k_i){
    re = r_x;
    im = k_i;
  }

  String toString(){
    return re + " + " + im + "i";
  }
}

void testComplex(){
  Complex c1,c2;
  c1 = new Complex(5,2);
  c2 = new Complex(1,4);
  println(c1);
  println(c2);
  println("sum: " + sum(c1,c2));
  println("diff: " + diff(c1,c2));
  println("mul: " + mul(c1,c2));
}

//c1.sum(c2);
//return sum(c1, c2);

Complex sum(Complex lhs, Complex rhs){
  return new Complex(lhs.re + rhs.re, lhs.im + rhs.im);
}

Complex diff(Complex lhs, Complex rhs){
  return new Complex(lhs.re - rhs.re, lhs.im - rhs.im);
}

Complex mul(Complex lhs, Complex rhs){
  Complex temp = new Complex(0, 0);
  //complex a, b;
  // a * b
  // a is the left hand side of the operation
  // b is the right hand side of the operation
  //(lsh.re + lhs.im)*(rhs.re + rhs.im)
  // lhs.re*rhs.re + lhs.re*rhs.im + lhs.im*rhs.re + lhs.im*rhs.im

  temp.re = lhs.re*rhs.re + lhs.im*rhs.im*-1; //*-1 for i^2
  temp.im = lhs.re*rhs.im + lhs.im*rhs.re;
  return temp;
}

