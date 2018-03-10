


data Program a    =  Decpart (Decls a) | Body (Stmts a)
type Decls a      =  [Decl a]
data Decl a       =  D a  -- Variable | Array
data VarDecl a    =  VarD Var (Type a)
data ArrayDecl a  =  ArrayD Var (Type a)
data Type a       =  T a  -- Int | Float | Bool | Char
type Stmts a      =  [Stmt a]
data Stmt a       =  S a  -- Skip | Block | Assnmt | Condl | Loop
data Skip         =  Skip
type Block a      =  Stmts a
data Condl a      =  Condl (Expr a) (Stmt a) (Stmt a) -- then branch; else branch
data Loop a       =  Loop (Expr a) (Expr a)  -- test; body


data Assnmt a     =  Assnmt (VarRef a) (Expr a)  -- target; source
data Expr a       =  E a  --  Binary | Unary | VarRef | Value 

data Binary a     =  Binary (BinOp a) (Expr a) (Expr a)  -- term1; term2
data BinOp a      =  Op a  -- BoolOp | RelOp | ArithOP
data BoolOp a     =  BoolOp a  -- (&&) | (||)
data RelOp a      =  RelOp a  -- (==) | (/=) | (<) | (>) | (<=) | (>=)
data ArithOp a    =  ArithOp a  -- (+) | (-) | (*) | (/)

data Unary a      =  Unary (UnOp a) (Expr a)  -- term
data UnOp a       =  UnOp a  -- (-) | (Not)

data VarRef a     =  VarRef a  -- Var | ArrayRef
data Var          =  Var String
data ArrayRef a   =  ArrayRef String (Expr a)  -- index

data Value a      =  V a  -- IntVal | FloatVal | BoolVal | CharVal
data IntVal a     =  IntV a  -- Int
data FloatVal a   =  FloatV a  -- Float
data BoolVal a    =  BoolV a  -- Bool
data CharVal a    =  CharV a  -- Char


