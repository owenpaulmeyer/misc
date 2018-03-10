import Abstract

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

letter :: Parser Char
letter = sat isAlpha

alphanum :: Parser Char
alphanum = sat isAlphaNum

nums = many1 digit

ident      = do {
				l <- letter;
				lns <- many alphanum;
				return (l:lns)
				}

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

symbol :: String -> Parser String
symbol cs = token (string cs)

apply :: Parser a -> String -> [(a,String)]
apply p = parse (do {space; p})


----------------------------------------

assignment = do {
				i  <- identifier;
				symbol "[";
				e1 <- expression;
				symbol "]";
				symbol "=";
				e2 <- expression;
				return (Assnmt (ArrayRef i e1) e2)
				}
				+++
			 do {	
				i  <- identifier;
				symbol "=";
				e2 <- expression;
				return (Assnmt (Variable i) e2)
				}

expression   =  conjunction `chainl1` orOp
				
conjunction  =  equality `chainl1` andOp

equality     =  do {r1 <- relation; e <- relOp; r2 <- relation;
					return (Expr (Binary (RelOp e) r1 r2))}
				+++
				do {r <- relation; return r}

relation     =  do {a1 <- addition; r <- relOp; a2 <- addition;
					return (Expr (Binary (RelOp r) a1 a2))}
				+++
				do {a <- addition; return a}

addition     =  term `chainl1` addOp

term         =  factor `chainl1` mulOp

factor       =  do {o <- unOp; p <- primary; return (Expr ((Unary o) p))}+++
				do {e <- primary; return (e)}

primary      =  do	{
					i <- identifier;
					symbol "[";
					e <- expression;
					symbol "]";
					return (Expr (VarRef (ArrayRef i e)))
					}+++
				do	{
					i <- identifier;
					return (Expr (VarRef (Variable i)))
					}+++
				do	{
					l <- literal;
					return (Expr (Value l))
					}+++
				do	{
					symbol "(";
					e <- expression;
					symbol ")";
					return e
					}
{-                +++
				do	{
					t <- typE;
					symbol "(";
					e <- expression;
					symbol ")";
					return (T t);
					}
-}
literal      =  do  {b <- bool; return (B b)}+++
				do  {c <- character; return (C c)}+++
--				do  {f <- float; return (F f)}+++
				do  {i <- integer; return (I i)}

typE         =  do  {i <- string "int"; return (T INT)}+++
--				do  {f <- string "float"; return (T FLOAT)}+++
				do  {b <- string "bool";  return (T BOOL)}+++
				do  {c <- string "char";  return (T CHAR)}

bool		 =  do  {t <- string "true"; return (True)}+++
				do	{f <- string "false"; return (False)}

character    =  do	{c <- letter; return c}

--float        =  do  {n <- 

integer      =  do  {n <- nums; return ((read n) :: Int)}

unOp         =  do  {o <- symbol "-"; return (Minus)}+++
				do  {o <- symbol "!"; return (Not)}

orOp         =  do {symbol "||"; return
					(\e1 e2 -> Expr (Binary (BoolOp Or)e1 e2))}

andOp        =  do {symbol "&&"; return
					(\e1 e2 -> Expr (Binary (BoolOp And)e1 e2))}

relOp        =  do {symbol "=="; return Eq}
				+++
				do {symbol "!="; return NotEq}
				+++
				do {symbol "<="; return LtEq}
				+++
				do {symbol ">="; return GtEq}
				+++
				do {symbol "<"; return Lt}
				+++
				do {symbol ">"; return Gt}


addOp        =  do {symbol "+"; return
					(\e1 e2 ->Expr (Binary (ArithOp Add)e1 e2))}
				+++
				do {symbol "-"; return
					(\e1 e2 -> Expr (Binary (ArithOp Sub)e1 e2))}

mulOp        =  do {symbol "*"; return
					(\e1 e2 -> Expr (Binary (ArithOp Mul)e1 e2))}
				+++
				do {symbol "/"; return
					(\e1 e2 -> Expr (Binary (ArithOp Div)e1 e2))}

identifier   = do  {
					t <- token ident;
					if (elem t reserved) then fails else
						return t}

reserved = ["bool","else","float","int","true","char","false",
				"if","main","while"]
