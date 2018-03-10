//Design concept for Programming Langs. Midterm problem 8.)

abstract class Expr{}

class Operation extends Expr{
	Oper op;
	Expr ex1 ex2;

	Operation (Op o, Expr e1, Expr e2){
		op = o;
		ex1 = e1;
		ex2 = e2;
	}
}

class IntVal extends Expr{
	int val;

	IntVal (int v){val = v;}
}

class Var extends Expr{
	char a;

	Var (char i){a=i;}
}

class Oper {
	String op;
	
	Oper (String o){op=o;}
}

public class Parser {
	
	public Expr expression(){
		Expression e;
		if (token.isVar() ) e = Var(match(...) );
		else if (token.isIntVal() ) e = IntVal(match(...) );
		else if (token.isOper() ){
			Oper o = new Oper(match(...) );
			Expr e1 = expression();
			Expr e2 = expression();
		}
		else error();
		return e;
	}
}


