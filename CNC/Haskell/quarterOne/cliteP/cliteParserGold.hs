import Abstract

import Data.Char

import Control.Monad.Identity
import Control.Monad.Error
import Control.Monad.Reader
import Control.Monad.State
import Control.Monad.Writer 
infixr 5 +++



instance Monoid (Parser a) where
	mempty = P (\inp -> [])
	p `mappend` q = P (\inp -> parse p inp ++ parse q inp)

newtype Parser a = P {parse :: String -> [(a,String)]}

instance Functor Parser where
	fmap f p = P (\inp -> case parse p inp of
								[]        -> []
								[(v,out)] -> [(f v,out)] )

fails = P (\inp -> [])

--join :: Monad m => m (m a) -> m a
join' p = P (\inp -> case parse p inp of
						[]        -> []
						[(v,out)] -> parse v out)

instance Monad Parser where
	return a = P (\inp -> [(a,inp)])
--	p >>= f  = P (\inp -> concat [parse (f a) inp' | (a,inp') <- parse p inp])
	p >>= f  = join' . fmap f $ p

type Parse a = ErrorT String Parser a

runParse :: ErrorT e Parser a -> String -> [(Either e a, String)]
runParse par = parse (runErrorT par)



itomb :: Monad m => m (String -> [(Char, String)] )
itomb = return (\inp ->
			case inp of
				[] -> []
				(c:cs) -> [(c,cs)] )

sato p = do
	c <- itomb 0
	if p c then return c
	else return []

--it :: Monad m => String -> m [(Char, String)]
it [] = return []
it (c:cs) = return [(c,cs)]


item :: Parser Char
item = P (\inp -> case inp of
					[]     -> []
					(c:cs) -> [(c,cs)])

p1 +++ p2 = P (\inp -> case parse (p1 `mappend` p2) inp of
						[] -> []
						(x:xs) -> [x] )

--sat :: (Char -> Bool) -> Parser Char
sat p = do {c <- item; if p c then return c else mempty}

char c = sat (c ==)

--digit :: Parser Char
digit = sat isDigit

--letter :: Parser Char
letter = sat isAlpha

--alphanum :: Parser Char
alphanum = sat isAlphaNum

nums = many1 digit

ident      = do {
				l <- letter;
				lns <- many alphanum;
				return (l:lns)
				}

--string :: String -> Parser String
string "" = return ""
string (c:cs) = do {char c; string cs; return (c:cs)}

--many :: Parser a -> Parser [a]
many p = many1 p +++ return []

--many1 :: Parser a -> Parser [a]
many1 p = do {a <- p; as <- many p; return (a:as)}

--sepby :: Parser a -> Parser b -> Parser [a]
p `sepby` sep = (p `sepby1` sep) +++ return []

--sepby1 :: Parser a -> Parser b -> Parser [a]
p `sepby1` sep = do {
					a <- p;
					as <- many (do {sep; p});
					return (a:as)
					}

--chainl :: Parser a -> Parser (a -> a -> a) -> a -> Parser a
chainl p op a = (p `chainl1` op) +++ return a

--chainl1 :: Parser a -> Parser (a -> a -> a) -> Parser a
p `chainl1` op = do {a <- p; rest a}
			where
				rest a = (do
							f <- op
							b <- p
							rest (f a b))
						+++ return a


--space :: Parser String
space = many (sat isSpace)

--token :: Parser a -> Parser a
token p = do {space; a <- p; space; return a}

--symbol :: String -> Parser String
symbol cs = token (string cs)

--apply :: Parser a -> String -> [(a,String)]
apply p = parse (do {space; p})
-----------------------------------------


----------------------------------------

program   = do  {
				symbol "int";
				symbol "main";
				symbol "(";
				symbol ")";
				symbol "{";
				dcls <- declarations;
				stmts <- statements;
				symbol "}";
				return (Prog dcls stmts)}

declarations = do {dcls <- many declaration; return (concat dcls)}

declaration = do  {
				t <- typE;
				va <- varsarrays;
				dcs <- many decs;
				symbol ";";
				return (map ($t) (va:dcs))
				}

decs      = do  {
				symbol ",";
				i <- identifier;
				symbol "[";
				n <- integer;
				symbol "]";
				return (\t -> D (ArrayD (Var i) t n))
				}+++
			do  {
				symbol ",";
				i <- identifier;
				return (\t -> D (VarD (Var i) t))
				}

varsarrays = do {
				i <-identifier;
				symbol "[";
				n <- integer;
				symbol "]";
				return (\t -> D (ArrayD (Var i) t n))
				}+++
			do	{
				i <- identifier;
				return (\t -> D (VarD (Var i) t))
				}

statements = do {stmts <- many statement; return stmts}

statement = do  {
				s <- block;
				return (S (Bl s))
				}+++
			do	{
				a <- assignment;
				return (S (As a))
				}+++
			do	{
				i <- ifStmt;
				return (S i)
				}+++
			do	{
				w <- whileStmt;
				return (S w)
				}+++
			do  {
				symbol ";";
				return (S Skip)}

block      = do {
				symbol "{";
				s <- many1 statement;
				symbol "}";
				return s
				}

ifStmt     =  do {
				symbol "if";
				symbol "(";
				e <- expression;
				symbol ")";
				s1 <- statement;
				symbol "else";
				s2 <- statement;
				return (Co (Condl e s1 s2))
				}+++
				do {
				symbol "if";
				symbol "(";
				e <- expression;
				symbol ")";
				s <- statement;
				return (Co (Condl e s (S Skip)))
				}

whileStmt  = do {
				symbol "while";
				symbol "(";
				e <- expression;
				symbol ")";
				s <- statement;
				return (Lo (Loop e s))
				}



assignment = do {
				i  <- identifier;
				symbol "[";
				e1 <- expression;
				symbol "]";
				symbol "=";
				e2 <- expression;
				symbol ";";
				return (Assnmt (ArrayRef i e1) e2)
				}
				+++
			 do {	
				i  <- identifier;
				symbol "=";
				e2 <- expression;
				symbol ";";
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
					t <- typE;
					symbol "(";
					e <- expression;
					symbol ")";
					return (Expr (Unary (Cast t) e));
					}
				+++
				do	{
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
                

literal      =  do  {b <- bool; return (B b)}+++
				do  {c <- character; return (C c)}+++
				do  {f <- float; return (F f)}+++
				do  {i <- integer; return (I i)}

typE         =  do  {symbol "int"; return (INT)}+++
				do  {symbol "float"; return (FLOAT)}+++
				do  {symbol "bool";  return (BOOL)}+++
				do  {symbol "char";  return (CHAR)}

bool		 =  do  {string "true"; return (True)}+++
				do	{string "false"; return (False)}

character    =  do	{c <- letter; return c}

float        =  do  
					{
					n1 <- nums;
					symbol ".";
					n2 <- nums;
					return (read (n1++"."++n2) :: Float)}

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
					if (elem t reserved) then mempty else
						return t}

reserved = ["bool","else","float","int","true","char","false",
				"if","main","while"]

showit [(a,"")] = display 0 a

clone = "int main ( ) {int a, b, c, d; b = a; b = 5; d = c; c = 7; }"
fact = "int main ( ) { int n, i, f;n = 3;i = 1;f = 1;while (i < n) {i = i + 1;f = f * i; }}"

newt = "int main() {float a, x, result;a = 4.0;x = 1.0;while (x*x > a+0.0001 || x*x < a-0.0001 )x = (x + a/x)/2.0;result = x;}"
