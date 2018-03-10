// StaticTypeCheck.java

import java.util.*;

// Static type checking for Clite is defined by the functions 
// V and the auxiliary functions typing and typeOf.  These
// functions use the classes in the Abstract Syntax of Clite.


public class StaticTypeCheck {
	//populates the TypeMap with <Variable,Type> pairs
    public static TypeMap typing (Declarations d) {
        TypeMap map = new TypeMap();
        for (Declaration di : d){
			if (di instanceof VariableDecl)
				map.put ( ((VariableDecl)di).v, ((VariableDecl)di).t);
			else if  (di instanceof ArrayDecl){
				map.put ( ((ArrayDecl)di).v, ((ArrayDecl)di).t);
			}
		}
//            map.put (di.v, di.t);
        return map;
    }

    public static void check(boolean test, String msg) {
        if (test)  return;
        System.err.println(msg);
        System.exit(1);
    }

    public static void V (Declarations d) {
        for (int i=0; i<d.size() - 1; i++)
            for (int j=i+1; j<d.size(); j++) {
                Declaration di = d.get(i);
                Declaration dj = d.get(j);
				if (di instanceof VariableDecl){
					if (dj instanceof VariableDecl)
						check( ! ( ((VariableDecl)di).v.equals( ((VariableDecl)dj).v)),
							"duplicate declaration: " + ((VariableDecl)dj).v);
					else if (dj instanceof ArrayDecl)
						check( ! ( ((VariableDecl)di).v.equals( ((ArrayDecl)dj).v)),
							"duplicate declaration: " + ((ArrayDecl)dj).v);
				}					
				if (di instanceof ArrayDecl){
					if (dj instanceof ArrayDecl)
						check( ! ( ((ArrayDecl)di).v.equals( ((ArrayDecl)dj).v)),
							"duplicate declaration: " + ((ArrayDecl)dj).v);
					else if (dj instanceof VariableDecl)
						check( ! ( ((ArrayDecl)di).v.equals( ((VariableDecl)dj).v)),
							"duplicate declaration: " + ((VariableDecl)dj).v);
				}
					
            }
    } 

    public static void V (Program p) {
        V (p.decpart);
        V (p.body, typing (p.decpart));
    } 

    public static Type typeOf (Expression e, TypeMap tm) {
        if (e instanceof Value) return ((Value)e).type;
        if (e instanceof VariableRef) {
			if (e instanceof Variable){
				Variable v = (Variable)e;
				check (tm.containsKey(v), "undefined variable: " + v);
				return (Type) tm.get(v);
			}
			else if (e instanceof ArrayRef){
				System.out.println("fetching array type");
				ArrayRef a = (ArrayRef)e;
				Type ty = (Type) tm.get(a);
				check (tm.containsKey(a), "undefined array: " + a);
				return ty;
			}
        }
        if (e instanceof Binary) {
            Binary b = (Binary)e;
            if (b.op.ArithmeticOp( ))
                if (typeOf(b.term1,tm)== Type.FLOAT)
                    return (Type.FLOAT);
                else return (Type.INT);
            if (b.op.RelationalOp( ) || b.op.BooleanOp( )) 
                return (Type.BOOL);
        }
        if (e instanceof Unary) {
            Unary u = (Unary)e;
            if (u.op.NotOp( ))        return (Type.BOOL);
            else if (u.op.NegateOp( )) return typeOf(u.term,tm);
            else if (u.op.intOp( ))    return (Type.INT);
            else if (u.op.floatOp( )) return (Type.FLOAT);
            else if (u.op.charOp( ))  return (Type.CHAR);
        }
        throw new IllegalArgumentException("should never reach here");
    } 

    public static void V (Expression e, TypeMap tm) {
        if (e instanceof Value) 
            return;
        if (e instanceof VariableRef) {
			if (e instanceof Variable){
				Variable v = (Variable)e;
				check( tm.containsKey(v), "undeclared variable: " + v);
				return;
			}
			else if (e instanceof ArrayRef){
				System.out.println("checking array ref.");
				ArrayRef a = (ArrayRef)e;
				check( tm.containsKey(a), "undeclared array: " + a);
				check( typeOf(a.index(),tm)==Type.INT,"non integer index value");
				V (a.index(), tm);//index expression is valid
				return;
			}
        }
        if (e instanceof Binary) {
            Binary b = (Binary) e;
            Type typ1 = typeOf(b.term1, tm);
            Type typ2 = typeOf(b.term2, tm);
            V (b.term1, tm);
            V (b.term2, tm);
            if (b.op.ArithmeticOp( )){
				//added ->
				if(typ1 == Type.FLOAT)
					check( typ2 == Type.FLOAT || typ2 == Type.INT,
								   	"type error for" + b.op);
				else if(typ1 == Type.INT)
					check( typ2 == Type.FLOAT || typ2 == Type.INT || typ2 == Type.CHAR, 
									"type error for" + b.op);
				else throw new IllegalArgumentException("type error for" + b.op);
			}
				//added <-
			/*
                check( typ1 == typ2 &&
                       (typ1 == Type.INT || typ1 == Type.FLOAT)
                       , "type error for " + b.op);
			*/
			else if (b.op.RelationalOp( )){
				//added ->
				if(typ1 == Type.FLOAT)
					check( typ2 == Type.FLOAT || typ2 == Type.INT, 
									"type error for" + b.op);
				else if(typ1 == Type.INT) //added
					check( typ2 == Type.INT || typ2 == Type.CHAR, 
									"type error for" + b.op);
				else if(typ1 == Type.CHAR)
					check(typ2 == Type.INT || typ2 == Type.CHAR, 
									"type error for" + b.op);
				else throw new IllegalArgumentException("type error for" + b.op);
			}
				//added <-

            //    check( typ1 == typ2 , "type error for " + b.op);

            else if (b.op.BooleanOp( )) 
                check( typ1 == Type.BOOL && typ2 == Type.BOOL,
                       b.op + ": non-bool operand");
            else
                throw new IllegalArgumentException("should never reach here");
            return;
        }
        // student exercise
		if (e instanceof Unary) {
			Unary u = (Unary) e;
			Type t = typeOf(u.term,tm);
			V (u.term, tm);
			if (u.op.NotOp() )
				check(typeOf(u.term,tm)==Type.BOOL,
								"Booleon Operator, NonBoolean Operand");
			else if (u.op.NegateOp() )
				check(typeOf(u.term,tm)==Type.INT || typeOf(u.term,tm)==Type.FLOAT,
								"Negate Operator, NonNumeric Operand");
			else if (u.op.charOp() || u.op.floatOp())
				check(typeOf(u.term,tm)==Type.INT,"Illegal Cast");
			else if (u.op.intOp() )
				check(typeOf(u.term,tm)==Type.CHAR || typeOf(u.term,tm)==Type.FLOAT,
								"Illegal Cast");
			return;
		}
				//student end
		else throw new IllegalArgumentException("should never reach here");
    }

    public static void V (Statement s, TypeMap tm) {
        if ( s == null )
            throw new IllegalArgumentException( "AST error: null statement");
        if (s instanceof Skip) return;
        if (s instanceof Assignment) {
            Assignment a = (Assignment)s;
			if (a.target instanceof Variable){
				System.out.println("check variable ref: "+a.target.toString());
				check( tm.containsKey((Variable)a.target)
                   , " undefined Vtarget in assignment: " + a.target);
			}
			else if (a.target instanceof ArrayRef){
				System.out.println("checking array ref: "+ a.target.toString());
				check(tm.containsKey((ArrayRef)a.target),
					"undefined Atarget in assignment:" + a.target);
				V (a.target,tm);
			}
            V(a.source, tm);
            Type ttype = (Type)tm.get(a.target);
            Type srctype = typeOf(a.source, tm);
            if (ttype != srctype) {
                if (ttype == Type.FLOAT)
                    check( srctype == Type.INT
                           , "mixed mode assignment to " + a.target);
                else if (ttype == Type.INT)
                    check( srctype == Type.CHAR
                           , "mixed mode assignment to " + a.target);
                else
                    check( false
                           , "mixed mode assignment to " + a.target);
            }
            return;
        } 
        // student exercise
		if (s instanceof Conditional){
			//System.out.println("Looking at Conditional.");
			Conditional c = (Conditional) s;
			V(c.test, tm);
			check(typeOf(c.test, tm)==Type.BOOL,"NonBoolean Test Expression.");
			V (c.thenbranch, tm);
			V (c.elsebranch, tm);
			return;
		}
		if (s instanceof Loop){
			//System.out.println("Looking at Loop.");
			Loop l = (Loop) s;
			V (l.test, tm);
			check(typeOf(l.test, tm)==Type.BOOL,"NonBoolean Test Expression.");
			V (l.body, tm);
			return;
		}
		if (s instanceof Block){
			//System.out.println("Looking at Block.");
			Block b = (Block) s;
			for (Statement stm : b.members){
				V (stm, tm);
			}
			return;
		}
		// exercise end
		else throw new IllegalArgumentException("should never reach here");
    }

    public static void main(String args[]) {
        Parser parser  = new Parser(new Lexer(args[0]));
        Program prog = parser.program();
        // prog.display();           // student exercise
        System.out.println("\nBegin type checking...");
        System.out.println("Type map:");
        TypeMap map = typing(prog.decpart);
        map.display();   // student exercise
		//V(prog.decpart);
        V(prog);
    } //main

} // class StaticTypeCheck

