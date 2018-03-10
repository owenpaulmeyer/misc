import Parsing

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

---------------------------------------------------
--Parser

{-
Expr	::=		Term { (+|-) Term }
Term	::=		Factor { (*|/) Factor }
Factor	::=		Expr | Lit
Lit		::=		Int
-}
{-
expr = 
	do {
		t <- term;
	do {
		symbol "+";
		a <- expr;
		return (Op Add n a)
		}
	+++
	do {
		symbol "-";
		s <- expr;
		return (Op Sub n2 s)
		}
	+++
	return t
		}
-}
term = 
	do {
		f <- fact;
		symbol "*";
		m <- term;
		return (Op Mul f m)
		}
	+++
	do {
		f1 <- fact;
		symbol "/";
		d <- term;
		return (Op Div f1 d)
		}
	+++
	do {
		f <- fact;
		return f
		}

fact =
	do {
		symbol "(";
		e <- term;
		symbol ")";
		return e
		}
	+++
	do {
		d <- nat;
		return (Lit d)
		}


addit =
	do {
		n <- nat;
		let ns = many (do {symbol "+"; a <- trms; return a}) in
		case parse ns of
			[(_,[])] -> return (foldl (Op Add) (Lit n) ns)
			[(_,_)]  -> failure
		}
	+++
	do {
		n <- nat;
		ns <- many (do {symbol "-"; a <- trms; return a});
		return (foldl (Op Sub) (Lit n) ns)
		}

trms =
	do {
		n <- nat;
		let ns = many (do {symbol "*"; a <- nat; return a}) in
		case parse ns of
			[(_,[])] -> return (foldl (Op Mul) (Lit n) ns)
			[(_,_)]  -> failure
		}
	+++
	do {
		n <- nat;
		ns <- many (do {symbol "/"; a <- nat; return a});
		return (foldl (Op Div) (Lit n) ns)
		}


		

value [(n,_)] = eval n































adds = do {
		n1 <- muls;
		do {
			symbol "+";
			n2 <- nums;
			return (Op Add n1 n2)}+++
		do {
			symbol "-";
			n3 <- muls;
			return (Op Sub n1 n3)}+++
			return n1
			}

muls = do {
		n1 <- nums;
		do {
			symbol "*";
			n2 <- nums;
			return (Op Mul n1 n2)}+++
		do {
			symbol "/";
			n3 <- nums;
			return (Op Div n1 n3)}+++
			return n1
			}

nums = do {
		symbol "(";
		a <- adds;
		symbol ")";
		return a
			}+++
		do {
		d <- nat;
			return (Lit d)
			}






























{-
newtype Parser a = P {parse :: String -> [(a,String)]}

instance Functor Parser where
	fmap f p = P (\inp -> case parse p inp of
								[]        -> []
								[(v,out)] -> [(f v,out)] )

fails = P (\inp -> [])

join :: Monad m => m (m a) -> m a
join p = p >>= id 

instance Monad Parser where
	return a = P (\inp -> [(a,inp)])
	p >>= f  = join . fmap f $ p


item :: Parser Char
item = P (\inp -> case inp of
					[]     -> []
					(c:cs) -> [(c,cs)])

p1 +++ p2 = P (\inp -> case parse p1 inp of
						[] -> parse p2 inp
						[(v,out)] -> [(v,out)] )

test :: (Char -> Bool) -> Parser Char
test a = do
			v <- item
			if a v then return v else fails

-}
