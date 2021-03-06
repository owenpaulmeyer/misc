
abstract class Term
case class Var(name: String) extends Term
case class Abs(arg: String, body: Term) extends Term
case class App(f: Term, v: Term) extends Term
case class Const(f: String) extends Term


def mem(x:String, xs:List[String]): Boolean = xs match {
  case Nil => false
  case y::ys => if (x == y) true else mem(x, ys)
}

def setdiff(xs:List[String], ys:List[String]):List[String] = xs match {
  case Nil => Nil
  case z::zs => if (ys.isEmpty) xs
				else if (mem(z, ys)) setdiff(zs, ys)
				else z::(setdiff(zs, ys))
}

def un(xs:List[String], ys:List[String]):List[String] = xs match {
  case Nil => ys
  case z::zs => if (ys.isEmpty) xs
				else if (mem(z,ys))  un(zs,ys)
				else z::(un(zs,ys))
}

def fv(m:Term) : List[String] = m match {
  case Var(v) => v::Nil
  case Abs(v,e) => setdiff((fv(e)),(v::Nil))
  case App(e1,e2) => un(fv(e1),fv(e2))
}


def min(ys:List[String]): String = ys match {
  case Nil => "x"
  case x::Nil => x
  case x::xs => val m = min(xs)
				if (x < m) x else m
}

def fresh(vars:List[String]): String =  {
	val a = "'"
	val b = min(vars)
	b.concat(a)
}

def sub(m:Term, x:Term, body:Term) : Term = (x,body) match {
	case (Var(y), Var(v))		=> if (y == v) m else Var(v)
	case (Var(y), App(e1, e2))	=> App(sub(m,x,e1), sub(m,x,e2))
	case (Var(y), Abs(v,e))		=>	if (y==v) Abs(v,e)
								else if (!mem(y,fv(e)) || !mem(v,fv(m)))
									Abs(v, sub(m,x,e))
								else {
									val z = fresh(un(fv(m), fv(e)))
									Abs (z, sub(m,x,sub(Var(z), Var(v), e)))
								}
}


def reduce(term: Term) : Term = term match {
  case Var(n)				=> Var(n)
  case App((Abs(v,e)), e2)	=> sub(e2,Var(v),e)
  case App(e1,e2)			=> App(reduce(e1), reduce(e2))
  case Abs(v,e)				=> Abs(v, reduce(e))
  case Const(f)				=> f match {
	case "Pair"					=> Abs("x", Abs("y", Abs("p", App(App(Var("p"), Var("x")), Var("y")))))
	case "Second"				=> Abs("p",App(Var("p"),Abs("a",Abs("b",Var("b")))))
	case "First"				=> Abs("p",App(Var("p"),Abs("a",Abs("b",Var("a")))))

  }
}

def reDuce(term: Term) : Term = if (reduce(term)==term) {
	term
	}else { reDuce(reduce(term)) }

def cbn(term: Term) : Term = term match {
	case Const(x)		=> Const(x)
	case Var(x)			=> Var(x)
	case Abs(x, e)		=> Abs(x, e)
	case App(e1, e2)	=> cbn(e1) match {
		case Abs(x, e)		=> cbn(sub(e2, Var(x), e))
		case ee1 : Term		=> App(ee1,e2)
	}
}
def nor(term: Term) : Term = term match {
	case Const(x)		=> Const(x)
	case Var(x)			=> Var(x)
	case Abs(x, e)		=> Abs(x, (nor(e)))
	case App(e1, e2)	=> cbn(e1) match {
		case Abs(x, e)		=> nor(sub(e2, Var(x), e))
		case ee1 : Term		=> App(nor(ee1), nor(e2))
	}
}

def show(term: Term) : String = term match {
	case Const(x)		=> x
	case Var(x)			=> x
	case Abs(x, e)		=> "\\" + x + " -> " + show(e)
	case App(e1, e2)	=> "(" + show(e1) + " " + show(e2) + ")"
}

val pair  = Abs("x", Abs("y", Abs("p", App(App(Var("p"), Var("x")), Var("y")))))
val first = Abs("p",App(Var("p"),Abs("a",Abs("b",Var("a")))))
val scnd  = Abs("p",App(Var("p"),Abs("a",Abs("b",Var("b")))))
val xy    = App(App(pair,Var("X")),Var("Y"))
val Pr    = Const("Pair")
val Fst   = Const("First")
val Snd   = Const("Second")

val zero = Abs("f", Abs("x", Var("x")))
val one = Abs("f", Abs("x", App(Var("f"), Var("x"))))
val add = Abs("n", Abs("m", Abs("f", Abs("x", App(App(Var("n"), Var("f")), App(App (Var("m"), Var("f")), Var("x")))))))



val n = App ( Abs("x",App(App(Var("x"),one),one)),Const("Add") ) 









