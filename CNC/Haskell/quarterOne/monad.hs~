{-
expression parser for {+,-,*,/,(,)} based on:

FUNCTIONAL PEARLS
Monadic Parsing in Haskell
Graham Hutton
University of Nottingham
Erik Meijer
University of Utrecht

parse expr " {some expression} " to get a tree
(I defined show for the data structure to show 
the tree as an expression)
value $ parse expr "{some expression}" to evaluate
the expression.

Also I redifined bind: p >>= f = join . fmap f $ p
where I provided definitions of join and fmap to
work for the Parser.






-}

import Data.Char

infixr 5 +++

class Monad m => MonadZero m where
	zero :: m a

class  MonadZero m => MonadPlus m where
	mplus :: m a -> m a -> m a

instance MonadZero Parser where
	zero = P (\inp -> [])

instance MonadPlus Parser where
	p `mplus` q = P (\inp -> parse p inp ++ parse q inp)

newtype Parser a = P {parse :: String -> [(a,String)]}

instance Functor Parser where
	fmap f p = P (\inp -> case parse p inp of
								[]        -> []
								[(v,out)] -> [(f v,out)] )

fails = P (\inp -> [])

--join :: Monad m => m (m a) -> m a
join p = P (\inp -> case parse p inp of
						[]        -> []
						[(v,out)] -> parse v out)

instance Monad Parser where
	return a = P (\inp -> [(a,inp)])
--	p >>= f  = P (\inp -> concat [parse (f a) inp' | (a,inp') <- parse p inp])
	p >>= f  = join . fmap f $ p

item :: Parser Char
item = P (\inp -> case inp of
					[]     -> []
					(c:cs) -> [(c,cs)])

p1 +++ p2 = P (\inp -> case parse (p1 `mplus` p2) inp of
						[] -> []
						(x:xs) -> [x] )

sat :: (Char -> Bool) -> Parser Char
sat p = do {c <- item; if p c then return c else zero}

char c = sat (c ==)
digit = sat isDigit

string :: String -> Parser String
string "" = return ""
string (c:cs) = do {char c; string cs; return (c:cs)}

many :: Parser a -> Parser [a]
many p = many1 p +++ return []

many1 :: Parser a -> Parser [a]
many1 p = do {a <- p; as <- many p; return (a:as)}

sepby :: Parser a -> Parser b -> Parser [a]
p `sepby` sep = (p `sepby1` sep) +++ return []

sepby1 :: Parser a -> Parser b -> Parser [a]
p `sepby1` sep = do {
					a <- p;
					as <- many (do {sep; p});
					return (a:as)
					}

chainl :: Parser a -> Parser (a -> a -> a) -> a -> Parser a
chainl p op a = (p `chainl1` op) +++ return a

chainl1 :: Parser a -> Parser (a -> a -> a) -> Parser a
p `chainl1` op = do {a <- p; rest a}
			where
				rest a = (do
							f <- op
							b <- p
							rest (f a b))
						+++ return a


space :: Parser String
space = many (sat isSpace)

token :: Parser a -> Parser a
token p = do {space; a <- p; space; return a}

symb :: String -> Parser String
symb cs = token (string cs)

apply :: Parser a -> String -> [(a,String)]
apply p = parse (do {space; p})

addop = do {symb "+"; return (Op Add)} +++ do {symb "-"; return (Op Sub)}
mulop = do {symb "*"; return (Op Mul)} +++ do {symb "/"; return (Op Div)}

--digit = do {x <- token (sat isDigit); return (ord x - ord '0')}

--nat :: Parser Int
nat = do
	xs <- token (many1 digit)
	return (Lit (read xs))


expr = term `chainl1` addop
term = factor `chainl1` mulop
factor = nat +++ do {symb "("; n <- expr; symb ")"; return n}

value [(ex,_)] = eval ex

ex [(ex,_)] = ex

------------------------------------------------
--Data Structure for expressions

data Expr = Lit Int | Op BinOp Expr Expr

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
