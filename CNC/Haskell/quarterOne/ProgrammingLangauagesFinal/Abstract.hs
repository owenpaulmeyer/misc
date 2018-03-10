module Abstract where


data Program      =  Prog StructDefs Decls Stmts
type StructDefs   =  [StructDef]
data StructDef    =  SD String Fields
type Decls        =  [Decl]
data Decl         =  D Dtype  	-- Variable | Array | Struct
data Dtype        =  VarD Var Type |
					 ArrayD Var Type Int |
					 StructD Var Type

type Fields       =  Decls 
data Type         =  INT | FLOAT | BOOL | CHAR | Struct String | STRING
--data SType        =  ST Var --struct type
type Stmts        =  [Stmt]
data Stmt         =  S Stype  	-- Skip | Block | Assnmt | Condl | Loop
data Stype        =  Skip |
					 Bl Block |
					 As Assnmt |
					 Co Condl |
					 Lo Loop |
					 Pu Put

type Block        =  Stmts
data Condl        =  Condl Expr Stmt Stmt -- test, then branch, else branch
data Assnmt       =  Assnmt Reference Expr -- target; source
data Loop         =  Loop Expr Stmt  -- test; body
data Put          =  Put StringCont
type StringCont   =  Expr  -- the string itself
data Expr         =  Expr Etype deriving Show 	--  Binary | Unary | VarRef | Value 
data Etype        =  Binary BinOp Expr Expr |
					 Unary UnOp Expr |
					 VarRef Reference |
					 Value Values deriving Show

data BinOp        =  BoolOp Bop | RelOp Rop | ArithOp Aop | StringOp Sop
data Bop          =  And | Or
data Rop          =  Eq | NotEq | Lt | Gt | LtEq | GtEq
data Aop          =  Add | Sub | Mul | Div deriving Eq
data Sop          =  Concat

data UnOp         =  Minus | Not | Cast Type deriving Show

data Var          =  Var String
data Reference    =  Variable String | ArrayRef String Expr |
						StructRef String Reference deriving Show
data Values       =  I IntVal | F FloatVal | B BoolVal | C CharVal | Str StringVal deriving Show
type StringVal    =  String
type IntVal       =  Int
type FloatVal     =  Float
type BoolVal      =  Bool
type CharVal      =  Char



---------------------
class Display a where
	display :: Int -> a -> IO ()

instance Display Program where
	display n (Prog stdefs dcls stms) = 
		do {
			putStr "Program:\nStructDefs: {";
			displayStructDefs stdefs;
			putStr "}\n";
			putStr "Declarations: {";
			displayDecs dcls;
			putStr "}\n";
			putStr "Statements:\n";
			displayStmts n stms} 

displayStructDefs [] = putStr ""
displayStructDefs (s:ss) = do
	displayStructDef s
	displayStructDefs ss

displayStructDef (SD v fields) = do
	putStr (v++"[ ")
	displayDecs fields
	putStr " ]"

instance Show Decl where
	show (D dt) = show dt
instance Show Dtype where
	show (VarD v t) = "<"++show t++": "++show v++">"
	show (ArrayD v t i) = "<"++show t++"["++show i++"]"++": "++show v++">"
	show (StructD v t)  = "<"++show t++": "++show v++">"
--	show (StringD v)      = "<String: "++show v++">"

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
	display n (Pu put )  = display n put

instance Display Put where
	display n (Put put) =
		do {
			putStr (tab n);
			putStr "Put:\n";
			display (n+1) put;} 

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

instance Display Reference where
	display n (Variable str) = putStr ((tab n)++"Variable: "++str++"\n")
	display n (ArrayRef str expr) =
		do {
			putStr (tab n);
			putStr ("Array: "++str++"\n");
			putStr ((tab (n+1))++"Index: ");
			display 0 expr}
	display n (StructRef str ref) =
		do {
			putStr (tab n);
			putStr ("Struct: "++str++"\n");
			display (n+1) ref}

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
			putStr (tab n);
			putStr "Unary Expression: ";
			putStr (show op++"\n");
			display (n+1) exp;}
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
	display n (Str str) = do {
						putStr (tab n);
						putStr ("StringValue: "++show str++"\n")}






tab :: Int -> String
tab 0 = ""
tab n = "  "++tab (n-1)

--instance Show SType where
--	show (ST t) = show t
instance Show Var where
	show (Var str) =  str
instance Show BinOp where
	show (BoolOp op) = show op
	show (RelOp op) = show op
	show (ArithOp op) = show op
	show (StringOp op) = show op

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

instance Show Type where
	show INT = "Int"
	show FLOAT = "Float"
	show BOOL = "Bool"
	show CHAR = "Char"
	show (Struct v) = "Struct "++v
	show STRING = "String"

instance Show Sop where
	show Concat = " (<++<) "
