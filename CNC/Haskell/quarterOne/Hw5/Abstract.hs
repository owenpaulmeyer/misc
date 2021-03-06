module Abstract where


data Program      =  Prog Decls Stmts
type Decls        =  [Decl]
data Decl         =  D Dtype  	-- Variable | Array
data Dtype        =  VarD Var Types | ArrayD Var Types Int 
data Types        =  INT | FLOAT | BOOL | CHAR
type Stmts        =  [Stmt]
data Stmt         =  S Stype  	-- Skip | Block | Assnmt | Condl | Loop
data Stype        =  Skip |
					 Bl Block |
					 As Assnmt |
					 Co Condl	|
					 Lo Loop 

type Block        =  Stmts
data Condl        =  Condl Expr Stmt Stmt -- test, then branch, else branch
data Assnmt       =  Assnmt References Expr -- target; source
data Loop         =  Loop Expr Stmt  -- test; body
data Expr         =  Expr Etype  	--  Binary | Unary | VarRef | Value 
data Etype        =  Binary BinOp Expr Expr |
					 Unary UnOp Expr |
					 VarRef References |
					 Value Values

data BinOp        =  BoolOp Bop | RelOp Rop | ArithOp Aop
data Bop          =  And | Or
data Rop          =  Eq | NotEq | Lt | Gt | LtEq | GtEq
data Aop          =  Add | Sub | Mul | Div deriving Eq

data UnOp         =  Minus | Not | Cast Types deriving Show

data Var          =  Var String
data References   =  Variable String | ArrayRef String Expr --Expr as array index
data Values       =  I IntVal | F FloatVal | B BoolVal | C CharVal
type IntVal       =  Int
type FloatVal     =  Float
type BoolVal      =  Bool
type CharVal      =  Char



---------------------
class Display a where
	display :: Int -> a -> IO ()

instance Display Program where
	display n (Prog dcls stms) = 
		do {
			putStr "Program:\n  Declarations: {";
			displayDecs dcls;
			putStr "}\n";
			putStr "  Statements:\n";
			displayStmts n stms}


displayDecs [] = putStr ""
displayDecs (d:ds) =
		do {
			putStr (show d);
			displayDecs ds}

displayStmts n [] = putStr ""
displayStmts n (s:ss) =
		do {
			display n s;
			displayStmts n ss}

instance Display Stmt where
	display n (S styp) = display (n+1) styp

instance Display Stype where
	display n Skip      = putStr ""
	display n (Bl bl)   = displayStmts n bl
	display n (As assn) = display n assn
	display n (Co cond) = display n cond
	display n (Lo loop)  = display n loop

instance Display Assnmt where
	display n (Assnmt refs expr) =
		do {
			putStr (tab n);
			putStr "Assignment:\n";
			putStr (tab (n+1));
			putStr "Target:\n";
			display (n+2) refs;
			putStr (tab (n+1));
			putStr "Source:\n";
			display (n+2) expr}

instance Display Condl where
	display n (Condl expr s1 s2) =
		do {
			putStr (tab n);
			putStr "Condition:\n";
			putStr (tab n);
			display n expr;
			display n s1;
			display n s2}

instance Display Loop where
	display n (Loop ex st) =
		do {
			putStr (tab n);
			putStr "Loop:\n";
			putStr (tab (n+1));
			putStr "While:\n";
			display (n+2) ex;
			display (n) st;}

instance Display References where
	display n (Variable str) = putStr ((tab n)++"Variable:  "++str++"\n")
	display n (ArrayRef str expr) =
		do {
			putStr (tab n);
			putStr (str++"\n");
			display n expr}

instance Display Expr where
	display n (Expr etype) = display n etype
instance Display Etype where
	display n (Binary op e1 e2) =
		do {
			putStr (tab n);
			putStr "Binary Expression:";
			putStr (show op++"\n");
			display (n+1) e1;
			display (n+1) e2}
	display n (Unary op exp) =
		do {
--			putStr (tab n);
			putStr (show op);
			display n exp;}
--			putStr "\n"}
	display n (VarRef refs) =
		do {
--			putStr (tab n);
			display n refs}
	display n (Value vals) =
		do {
--			putStr (tab n);
			display n vals}

instance Display Values where
	display n (I int) = do{
						putStr (tab n);
						putStr ("IntValue:  "++show int++"\n")}
	display n (F float) = do{
						putStr (tab n);
						putStr ("FloatValue:  "++show float++"\n")}
	display n (B bool)  = do{
						putStr (tab n);
						putStr ("BoolValue:  "++show bool++"\n")}
	display n (C char) = do{
						putStr (tab n);
						putStr ("CharValue:  "++show char++"\n")}


instance Show Decl where
	show (D dt) = show dt
instance Show Dtype where
	show (VarD v t) = "< "++show t++": "++show v++" >"
	show (ArrayD v t i) = "<"++show t++"["++show i++"]"++": "++show v++">"






tab :: Int -> String
tab 0 = ""
tab n = "  "++tab (n-1)


instance Show Var where
	show (Var str) =  str
instance Show BinOp where
	show (BoolOp op) = show op
	show (RelOp op) = show op
	show (ArithOp op) = show op

instance Show Aop where
	show Add = " (+) "
	show Sub = " (-) "
	show Mul = " (*) "
	show Div = " (/) "

instance Show Bop where
	show Or = " (Or) "
	show And = " (And) "

instance Show Rop where
	show Eq = " (==) "
	show NotEq = " (!=) "
	show Lt = " (<) "
	show Gt = " (>) "
	show LtEq = " (<=) "
	show GtEq = " (>=) "

instance Show Types where
	show INT = "Int"
	show FLOAT = "Float"
	show BOOL = "Bool"
	show CHAR = "Char"
