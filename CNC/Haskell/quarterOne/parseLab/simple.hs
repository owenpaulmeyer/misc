import Data.Char

infixr 5 +++

---------------------------------------------------------------
--Examples of simple grammer parsers with data type definitions
--

data V = V S O V | T S
data S = Aval | Bval
data O = O

instance Show V where
	show (T a) = show a
	show (V s o v) = show s++show o++show v
instance Show S where
	show Aval = "A"
	show Bval = "B"
instance Show O where
	show O = " o "

ruleA = do {
	       s <- ruleS;
	       o <- symbol "o";
	       a <- ruleA;
	       return (V s O a)
	       } +++
	    do {
	       s <- ruleS;
	       return (T s)
	       }
ruleS = do {
		   a <- symbol "A";
		   return Aval
		   } +++
		do {
		   b <- symbol "B";
		   return Bval
		   }

test inp = case parse ruleA inp of
	[(a,"")] -> a
	_ -> error("didn't parse")

----------------------------------------------
data Es = EE A Es D D | EE' Ae
data Ae = AA B Ae C | AA' B C
data A = A
data B = B
data C = C
data D = D

instance Show Es where
	show (EE a e d d') = "a"++show e++"dd"
	show (EE' a) = show a
instance Show Ae where
	show (AA b a c) = "b"++show a++"c"
	show (AA' b c) = "bc"

ruleSS = do
			{
			symbol "a";
			s <- ruleSS;
			symbol "d";
			symbol "d";
			return (EE A s D D)
			} +++
		 do
			{
			a <- ruleAA;
			return (EE' a)}
ruleAA = do
			{
			symbol "b";
			a <- ruleAA;
			symbol "c";
			return (AA B a C)
			} +++
		 do {
			symbol "b";
			symbol "c";
			return (AA' B C)}

---------------------------------------------------
data Expr = Lit Int | Op BinOp Expr Expr
data BinOp = Add | Sub

instance Show Expr where
	show (Lit n) = show n
	show (Op b e1 e2) =  "(" ++ show e1 ++ show b ++ show e2 ++ ")"

instance Show BinOp where
	show Add = " + "
	show Sub = " - "

addop = do {symbol "+"; return (Op Add)} +++ do {symbol "-"; return (Op Sub)}

nat = do {
		 n <- token (many1 digit);
	 	 return (read n :: Int)
		 }

term :: Parser Expr
term = do {
	      n <- nat;
	      return (Lit n)
	      }

expr = term `chainl1` addop

test'  inp = case parse expr inp of
	[(a,"")] -> a
	_ -> error("didn't parse")

result :: String -> (Expr -> t) -> t
result inp eval = case parse expr inp of
	[(a,"")] -> eval a
	_ -> error("invalid expression")

eval = id
----------------------------------------------------
--the foundational parsers

fails = P (\inp -> [])

item :: Parser Char
item = P (\inp -> case inp of
					[]     -> []
					(c:cs) -> [(c,cs)])

------------------------------------------------------
--some matching parsers; based in sat (some use many /
--many1 from next section below)

sat :: (Char -> Bool) -> Parser Char
sat p = do {c <- item; if p c then return c else zero}

char :: Char -> Parser Char
char c = sat (c ==)

digit :: Parser Char
digit = sat isDigit

letter :: Parser Char
letter = sat isAlpha

alphanum :: Parser Char
alphanum = sat isAlphaNum

space :: Parser String
space = many (sat isSpace)

nums :: Parser String
nums = many1 digit

letters :: Parser String
letters = many1 letter

string :: String -> Parser String
string "" = return ""
string (c:cs) = do {char c; string cs; return (c:cs)}

token :: Parser a -> Parser a
token p = do {space; a <- p; space; return a}

symbol :: String -> Parser String
symbol cs = token (string cs)

-----------------------------------------------------
--more advanced parsers;  

--applies a parser zero or more times (like Kleene star in RE's)
many :: Parser a -> Parser [a]
many p = many1 p +++ return []

--applies a parser one or more times (like + in RE's)
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


-----------------------------------------------------
--The underlying structure of the parser monad

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

join' p = P (\inp -> case parse p inp of
						[]        -> []
						[(v,out)] -> parse v out)

instance Monad Parser where
	return a = P (\inp -> [(a,inp)])
	p >>= f  = join' . fmap f $ p

p1 +++ p2 = P (\inp -> case parse (p1 `mplus` p2) inp of
						[] -> []
						(x:xs) -> [x] )

