data Expr = Lit Int
          | Op BinOp Expr Expr
data BinOp = Add | Sub | Mul | Div deriving Eq



instance Show Expr where
	show (Lit i) = show i
	show (Op b x y)
		|b==Mul || b==Div = show x++show b++show y
		|otherwise        = "("++show x++show b++show y++")"

instance Show BinOp where
	show Add = "+"
	show Sub = "-"
	show Mul = "*"
	show Div = "/"

size :: Expr -> Int
size (Lit i) = 0
size (Op o e1 e2) = 1+size e1+size e2

--eval :: Expr -> Float
eval (Lit i) = fromIntegral i
eval (Op o e1 e2)
	|o==Add = eval e1+eval e2
	|o==Sub = eval e1-eval e2
	|o==Mul = eval e1*eval e2
	|o==Div = eval e1/eval e2

