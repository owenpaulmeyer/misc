import java.util.*;

public class Parser {
    // Recursive descent parser that inputs a C++Lite program and 
    // generates its abstract syntax.  Each method corresponds to
    // a concrete syntax grammar rule, which appears as a comment
    // at the beginning of the method.
  
    Token token;          // current token from the input stream
    Lexer lexer;
  
    public Parser(Lexer ts) { // Open the C++Lite source program
        lexer = ts;                          // as a token stream, and
        token = lexer.next();            // retrieve its first Token
    }
  
    private String match (TokenType t) {
        String value = token.value();
        if (token.type().equals(t))
            token = lexer.next();
        else
            error(t);
        return value;
    }
  
    private void error(TokenType tok) {
        System.err.println("Syntax error: expecting: " + tok 
                           + "; saw: " + token + " linenum: "+lexer.lineno());
        System.exit(1);
    }
  
    private void error(String tok) {
        System.err.println("Syntax error: expecting: " + tok 
                           + "; saw: " + token+ " linenum: "+lexer.lineno());
        System.exit(1);
    }
  
    public Program program() {
        // Program --> void main ( ) '{' Declarations Statements '}'
		Declarations decs;
		Block stmts = new Block();
        TokenType[ ] header = {TokenType.Int, TokenType.Main,
                          TokenType.LeftParen, TokenType.RightParen};
        for (int i=0; i<header.length; i++)   // bypass "int main ( )"
            match(header[i]);
        match(TokenType.LeftBrace);
        decs = declarations();
		while(! token.type().equals(TokenType.RightBrace)){
			Statement st = statement();
			stmts.members.add(st);
		}
        match(TokenType.RightBrace);
        return new Program(decs, stmts);  // student exercise
    }
  
    private Declarations declarations () {
        // Declarations --> { Declaration }
		Declarations decs = new Declarations();
		while(isType()){
			declaration(decs);
		}
        return decs;  // student exercise
    }
  
    private void declaration (Declarations ds) {
        // Declaration  --> Type Identifier { , Identifier } ;

		Type t = type();
		//Expression v = primary();
		Variable name = new Variable(match(TokenType.Identifier) );
		//System.out.println("found Declrtn: "+v.toString());
		if(isLeftBracket() ){
			match(TokenType.LeftBracket); //consume leftBracket
			IntValue size = (IntValue) literal();
			match(TokenType.RightBracket);
			ds.add(new ArrayDecl(name,t,size));
		}
		else ds.add(new VariableDecl(name,t));
		while(isComma()){
			match(TokenType.Comma);
			name = new Variable(match(TokenType.Identifier) );
			if(isLeftBracket() ){
				match(TokenType.LeftBracket);
				IntValue size = (IntValue) literal();
				match(TokenType.RightBracket);
				ds.add(new ArrayDecl(name,t,size));
			}
			//System.out.println("found Declrtn: "+v2.toString());
			else ds.add(new VariableDecl(name,t));
		}
		match(TokenType.Semicolon);
        // student exercise
    }
  
    private Type type () {
        // Type  -->  int | bool | float | char
		//System.out.println("checking for Type.");
        Type t = null;
		if(token.type().equals(TokenType.Int))
			t = Type.INT;
		else if(token.type().equals(TokenType.Float))
			t = Type.FLOAT;
		else if(token.type().equals(TokenType.Char))
			t = Type.CHAR;
		else if(token.type().equals(TokenType.Bool))
			t = Type.BOOL;
		//else error("holy smokes! not a type");
        // student exercise
		token = lexer.next();
		//System.out.println("found Type");
        return t;          
    }
  
    private Statement statement() {
        // Statement --> ; | Block | Assignment | IfStatement | WhileStatement
        Statement s = new Skip();
		if(token.type().equals(TokenType.LeftBrace)){
			s = statements();
			//System.out.println("found Block ");
		}
		else if(token.type().equals(TokenType.Identifier)){
			s = assignment();
			//System.out.print("found Assign ");
		}
		else if(token.type().equals(TokenType.If)){
			s = ifStatement();
			//System.out.print("found If ");
		}
		else if(token.type().equals(TokenType.While)){
			s = whileStatement();
			//System.out.print("found While ");
		}
		else if(token.type().equals(TokenType.Semicolon)){
			token = lexer.next();
			System.out.print("found semicolon.");
			return s;
		}
		//else error("not a statement");
        // student exercise
		//System.out.println("type Stmt.");
        return s;
    }

    private Block statements () {
        // Block --> '{' Statements '}'
		//System.out.println("checking for Block.");
        Block b = new Block();
		match(TokenType.LeftBrace);
		while(! token.type().equals(TokenType.RightBrace)){
			Statement s = statement();
			b.members.add(s);
		}
		match(TokenType.RightBrace);
        // student exercise
        return b;
    }

    private Assignment assignment () {
        // Assignment --> Identifier = Expression ;
		//System.out.println("checking for assignment.");
		Expression targ = primary();
		match(TokenType.Assign);
		Expression source = expression();
		match(TokenType.Semicolon);
        return new Assignment((VariableRef)targ,source);  // student exercise
    }

    private Conditional ifStatement () {
        // IfStatement --> if ( Expression ) Statement [ else Statement ]
		//System.out.println("checking for ifStmt.");
		match(TokenType.If);
		match(TokenType.LeftParen);
		Expression e = expression();
		match(TokenType.RightParen);
		Statement s1 = statement();
		if(token.type().equals(TokenType.Else)){
			match(TokenType.Else);
			Statement s2 = statement();
			return new Conditional(e,s1,s2);
		}
		else return new Conditional(e,s1);
		// student exercise
    }

    private Loop whileStatement () {
        // WhileStatement --> while ( Expression ) Statement
		//System.out.println("checking for While.");
		match(TokenType.While);
		match(TokenType.LeftParen);
		Expression e = expression();
		match(TokenType.RightParen);
		Statement s = statement();
        return new Loop (e, s);  // student exercise
    }

    private Expression expression () {
        // Expression --> Conjunction { || Conjunction }
		//System.out.println("checking for expr.");
        Expression e = conjunction();
        while (isOr()) {
            Operator op = new Operator(match(token.type()));
            Expression e2 = conjunction();
            e = new Binary(op, e, e2);
        }
        return e;
    }
  
    private Expression conjunction () {
        // Conjunction --> Equality { && Equality }
		//System.out.println("checking for conj.");
        Expression e = equality();
        while (isAnd()) {
            Operator op = new Operator(match(token.type()));
            Expression e2 = equality();
            e = new Binary(op, e, e2);
        }
        return e;
    }
  
    private Expression equality () {
        // Equality --> Relation [ EquOp Relation ]
		//System.out.println("checking for equality.");
		Expression r1 = relation();
		if (isEqualityOp()){
			Operator op = new Operator(match(token.type()));
			Expression r2 = relation();
			return new Binary(op,r1,r2);
		}
		//lse error("noCanScoobyDoobieDooo"+lexer.lineno());
        return r1;  // student exercise
    }

    private Expression relation (){
        // Relation --> Addition [RelOp Addition]
		//System.out.println("checking for relational.");
		Expression a1 = addition();
		if (isRelationalOp()){
			Operator op = new Operator(match(token.type()));
			Expression a2 = addition();
			return new Binary(op,a1,a2);
		}
		else return a1;  // student exercise
    }
  
    private Expression addition () {
        // Addition --> Term { AddOp Term }
		//System.out.println("checking for addition.");
        Expression e = term();
        while (isAddOp()) {
            Operator op = new Operator(match(token.type()));
            Expression term2 = term();
            e = new Binary(op, e, term2);
        }
        return e;
    }
  
    private Expression term () {
        // Term --> Factor { MultiplyOp Factor }
		//System.out.println("checking for term.");
        Expression e = factor();
        while (isMultiplyOp()) {
            Operator op = new Operator(match(token.type()));
            Expression term2 = factor();
            e = new Binary(op, e, term2);
        }
        return e;
    }
  
    private Expression factor() {
        // Factor --> [ UnaryOp ] Primary
		//System.out.println("checking for factor.");
        if (isUnaryOp()) {
            Operator op = new Operator(match(token.type()));
            Expression term = primary();
            return new Unary(op, term);
        }
        else return primary();
    }

    private Expression primary () {
        // Primary --> Identifier | Literal | ( Expression )
        //             | Type ( Expression )
		//System.out.println("checking for primary.");
        Expression e = null;
        if (token.type().equals(TokenType.Identifier)) {
			String name = match(TokenType.Identifier);
			if(isLeftBracket() ){
				//	System.out.println("found array!!");
				match(TokenType.LeftBracket);
				Expression idx = expression();
				match(TokenType.RightBracket);
				e = new ArrayRef(name, idx);
			}
			else e = new Variable(name);
        } else if (isLiteral()) {
            e = literal();
        } else if (token.type().equals(TokenType.LeftParen)) {
            token = lexer.next();
            e = expression();       
            match(TokenType.RightParen);
        } else if (isType( )) { //cast
           Operator op = new Operator(match(token.type())); //constructs a cast operator.
            match(TokenType.LeftParen);
            Expression term = expression();
            match(TokenType.RightParen);
            e = new Unary(op, term); //constructs a casting to return
        } else error("Identifier | Literal | ( | Type");
        return e;
    }

    private Value literal( ) {
		//System.out.println("checking for literal value:  "+token.value());
		if (token.type().equals(TokenType.IntLiteral)){
			//System.out.println("checking for intVal.");
			Type t = Type.INT;
			int n = Integer.parseInt(token.value());
			Value v = new IntValue(n);
			token = lexer.next();
			return v;
		}
		else if (token.type().equals(TokenType.FloatLiteral)){
			//System.out.println("checking for floatVal.");
			Type t = Type.FLOAT;
			float n = Float.parseFloat(token.value());
			Value v = new FloatValue(n);
			token = lexer.next();
			return v;
		}
		else if (token.type().equals(TokenType.CharLiteral)){
			//System.out.println("checking for charVal.");
			Type t = Type.CHAR;
			char n = token.value().charAt(0);
			Value v = new CharValue(n);
			token = lexer.next();
			return v;
		}
		else if (isBooleanLiteral( )){
			//System.out.println("checking for boolVal.");
			Type t = Type.BOOL;
			boolean n = Boolean.valueOf(token.value());
			Value v = new BoolValue(n);
			token = lexer.next();
			return v;
		}
		else error("tried to parse literal where there was none.");
        return null;
    }

//	private boolean isStmnt(){
//		return (token.type().equals(TokenType.If) ||
//			token.type().equals(TokenType.While) ||
//			token.type().equals(TokenType.

	private boolean isOr( ) {
        return token.type().equals(TokenType.Or);
    }	

	private boolean isAnd( ) {
        return token.type().equals(TokenType.And);
    }
  

    private boolean isAddOp( ) {
        return token.type().equals(TokenType.Plus) ||
               token.type().equals(TokenType.Minus);
    }
    
    private boolean isMultiplyOp( ) {
        return token.type().equals(TokenType.Multiply) ||
               token.type().equals(TokenType.Divide);
    }
    
    private boolean isUnaryOp( ) {
        return token.type().equals(TokenType.Not) ||
               token.type().equals(TokenType.Minus);
    }
    
    private boolean isEqualityOp( ) {
        return token.type().equals(TokenType.Equals) ||
            token.type().equals(TokenType.NotEqual);
    }
    
    private boolean isRelationalOp( ) {
        return token.type().equals(TokenType.Less) ||
               token.type().equals(TokenType.LessEqual) || 
               token.type().equals(TokenType.Greater) ||
               token.type().equals(TokenType.GreaterEqual);
    }
    
    private boolean isType( ) {
        return token.type().equals(TokenType.Int)
            || token.type().equals(TokenType.Bool) 
            || token.type().equals(TokenType.Float)
            || token.type().equals(TokenType.Char);
    }
    
    private boolean isLiteral( ) {
        return token.type().equals(TokenType.IntLiteral) ||
            isBooleanLiteral() ||
            token.type().equals(TokenType.FloatLiteral) ||
            token.type().equals(TokenType.CharLiteral);
    }
    
    private boolean isBooleanLiteral( ) {
        return token.type().equals(TokenType.True) ||
            token.type().equals(TokenType.False);
    }

	private boolean isComma( ) {
        return token.type().equals(TokenType.Comma);
    }

	private boolean isLeftBracket(){
		return token.type().equals(TokenType.LeftBracket);
	}
    
    public static void main(String args[]) {
        Parser parser  = new Parser(new Lexer(args[0]));
        Program prog = parser.program();
		System.out.println("Output:");
		prog.display();           // display abstract syntax tree
    } //main

} // Parser
