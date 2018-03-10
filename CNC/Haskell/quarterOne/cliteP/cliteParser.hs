import Abstract
import Data.Char
import Control.Monad.State
import Control.Monad.Reader
import Control.Monad.Identity
import Control.Monad.Error
import Control.Monad.Writer
import Data.Monoid





newtype Parser a = P {parse :: String -> [(a,String)]}


instance Monoid (Parser a) where
	mempty = P (\inp -> [])
	mappend p q = P (\inp -> parse p inp ++ parse q inp)


instance Monad Parser where
	return a = P (\inp -> [(a,inp)])
	p >>= f = P (\inp -> case parse p inp of
				[] -> []
				[(v, out)] -> parse (f v) out)


newtype ParserT m a = PT {parseT :: String -> m [(a,String)]}

instance (Monad m) => Monad (ParserT m) where
	return a = PT (\inp -> return [(a,inp)] )
	p >>= f  = PT (\inp ->
					do
						parseVal <- parseT p inp
						case parseVal of
							[] -> return []
							[(v, out)] -> parseT (f v) out)

failT :: Monad m => (ParserT m) a
failT = PT (\inp -> return [])

getLines = liftM lines . readFile
--getLines "factorial.cpp"

{-
parseit = do
	prog <- getLines "factorial.cpp"
	showit$parse program $(concat prog)


concaT [] = []
concaT (l:ls) = l++"%"++concaT ls

zerp :: (StateT String IO) [(Char,String)]
zerp = do
	inp <- get
	return$parse item inp
-}
--------------------------------------------

itemT' :: ParseP Char
itemT' = PT (\inp -> do
					case inp of
						[]     -> return []
						(c:cs) -> return [(c,cs)])


type ParseP a = ParserT (StateT Int IO) a

itemT :: ParseP Char
itemT = PT (\inp -> do
					case inp of
						[]     -> return []
						(c:cs) -> do
							--liftIO $ putStr [c]
							if c=='%' then
								itemAlt cs
							else
								return [(c,cs)])


itemAlt = (\inp ->
		do
			--liftIO$putStr "here?"
			modify (+1)
			case inp of
				[] -> return []
				(c:cs) -> return [(c,cs)] )



choiceT :: ParseP a -> ParseP a -> ParseP a
choiceT p1 p2 = PT (\inp -> do
			--liftIO$putStr "c"
			parseVal <- parseT p1 inp
			case parseVal of
				[] -> parseT p2 inp
				[(v,out)] -> return parseVal)

--accounts for extra call of itemT by choiceT when [] is found
discount p = (\inp ->
	do 
		modify (\n -> (n-1))
		case inp of
			[] -> return []
			_ -> parseT p inp )

satT :: (Char -> Bool) -> ParseP Char
satT p = PT (\inp ->
	do
		--liftIO$putStr"s"
		parseVal <- parseT itemT inp
		case parseVal of
			[(c,out)] ->
				if p c then return [(c,out)]
				else parseT failT inp
			[] -> return [])

{-
--this also works
satT :: (Char -> Bool) -> ParseP Char
satT p = do
		c <- itemT
		if p c then return c
		else failT
-}

manyT :: ParseP a -> ParseP [a]
manyT p = manyT1 p `choiceT` (return [])

manyT1 :: ParseP a -> ParseP [a]
manyT1 p = do {a <- p; as <- manyT p; (return (a:as))}



symbolT :: [Char] -> ParseP [Char]
symbolT sym = tokenT (stringT sym)

tokenT :: ParseP b -> ParseP b
tokenT p = do {spaceT; a <- p; spaceT;return a}

spaceT:: ParseP [Char] 
spaceT = manyT (satT isSpace)


stringT :: [Char] -> ParseP [Char]
stringT "" = return []
stringT (c:cs) = PT (\inp ->
		do
			parseVal <- parseT (charT c) inp
			--liftIO$putStr "string"
			case parseVal of
				[] -> return []
				[(v,out)] -> do
					parseVal' <- parseT (stringT cs) out
					case parseVal' of
						[] -> return []
						[(v',out')] -> return [((c:cs),out')] )

{-

stringT :: [Char] -> ParseP [Char]
stringT "" = return ""
stringT (c:cs) = do {c' <- charT c; cs' <- stringT cs; return (c':cs')}

-}

{-
--stringT "" = return ""
stringT' (c:cs) = PT (\inp -> do
			[(v,out)] <- parseT (charT c) inp
			[(cs',out')] <- parseT stringRec cs
			return [((v:cs'),out')] )
stringRec (c:cs) = PT (\inp -> do
			[(v,out)] <- parseT (charT c) inp
			[(cs',out')] <- parseT stringT' cs
			return [((v:cs'),out')])
-}

charT :: Char -> ParseP Char
charT c = satT (==c)

identT = do
		l <- (satT isAlpha)
		lns <- manyT (satT isAlphaNum)
		return (l:lns)

line p = 
	do {
		l <- tokenT p;
		stringT "\t";
		return l} `choiceT`
	do {
		l <- tokenT p;
		return l}

--chainlT p op a = (p `chainl1` op) `choiceT` return a

chainlT1 :: ParseP b -> ParseP (b -> b -> b) -> ParseP b
p `chainlT1` op = do {a <- p; rest a}
			where
				rest a = (do
							f <- op
							b <- p
							rest (f a b)) `choiceT`
						 	return a

numsT = manyT1 (satT isDigit)

letterT = satT isAlpha
------------------------------------------------------

----------------------------------------
program :: ParseP Program
program   = do  {
				--liftIO$ putStr "here!";
				symbolT "int";
				symbolT "main";
				symbolT "(";
				symbolT ")";
				symbolT "{";
				dcls <- declarations;
				stmts <- statements;
				symbolT "}";
				return (Prog dcls stmts)}

declarations = do {dcls <- manyT declaration; return (concat dcls)}

declaration = do  {
				t <- typE;
				va <- varsarrays;
				dcs <- manyT decs;
				symbolT ";";
				return (map ($t) (va:dcs))
				}

decs      = do  {
				symbolT ",";
				i <- identifier;
				symbolT "[";
				n <- integer;
				symbolT "]";
				return (\t -> D (ArrayD (Var i) t n))
				}`choiceT`
			do  {
				symbolT ",";
				i <- identifier;
				return (\t -> D (VarD (Var i) t))
				}

varsarrays = do {
				i <-identifier;
				symbolT "[";
				n <- integer;
				symbolT "]";
				return (\t -> D (ArrayD (Var i) t n))
				}`choiceT`
			do	{
				i <- identifier;
				return (\t -> D (VarD (Var i) t))
				}

statements = do {stmts <- manyT statement; return stmts}

statement = do  {
				s <- block;
				return (S (Bl s))
				}`choiceT`
			do	{
				a <- assignment;
				return (S (As a))
				}`choiceT`
			do	{
				i <- ifStmt;
				return (S i)
				}`choiceT`
			do	{
				w <- whileStmt;
				return (S w)
				}`choiceT`
			do  {
				symbolT ";";
				return (S Skip)}

block      = do {
				symbolT "{";
				s <- manyT1 statement;
				symbolT "}";
				return s
				}

ifStmt     =  do {
				symbolT "if";
				symbolT "(";
				e <- expression;
				symbolT ")";
				s1 <- statement;
				symbolT "else";
				s2 <- statement;
				return (Co (Condl e s1 s2))
				}`choiceT`
				do {
				symbolT "if";
				symbolT "(";
				e <- expression;
				symbolT ")";
				s <- statement;
				return (Co (Condl e s (S Skip)))
				}

whileStmt  = do {
				symbolT "while";
				symbolT "(";
				e <- expression;
				symbolT ")";
				s <- statement;
				return (Lo (Loop e s))
				}



assignment = do {
				i  <- identifier;
				symbolT "[";
				e1 <- expression;
				symbolT "]";
				symbolT "=";
				e2 <- expression;
				symbolT ";";
				return (Assnmt (ArrayRef i e1) e2)
				}
				`choiceT`
			 do {	
				i  <- identifier;
				symbolT "=";
				e2 <- expression;
				symbolT ";";
				return (Assnmt (Variable i) e2)
				}

expression   =  conjunction `chainlT1` orOp
				
conjunction  =  equality `chainlT1` andOp

equality     =  do {r1 <- relation; e <- relOp; r2 <- relation;
					return (Expr (Binary (RelOp e) r1 r2))}
				`choiceT`
				do {r <- relation; return r}

relation     =  do {a1 <- addition; r <- relOp; a2 <- addition;
					return (Expr (Binary (RelOp r) a1 a2))}
				`choiceT`
				do {a <- addition; return a}

addition     =  term `chainlT1` addOp

term         =  factor `chainlT1` mulOp

factor       =  do {o <- unOp; p <- primary; return (Expr ((Unary o) p))}`choiceT`
				do {e <- primary; return (e)}

primary      =  do	{
					t <- typE;
					symbolT "(";
					e <- expression;
					symbolT ")";
					return (Expr (Unary (Cast t) e));
					}
				`choiceT`
				do	{
					i <- identifier;
					symbolT "[";
					e <- expression;
					symbolT "]";
					return (Expr (VarRef (ArrayRef i e)))
					}`choiceT`
				do	{
					i <- identifier;
					return (Expr (VarRef (Variable i)))
					}`choiceT`
				do	{
					l <- literal;
					return (Expr (Value l))
					}`choiceT`
				do	{
					symbolT "(";
					e <- expression;
					symbolT ")";
					return e
					}
                

literal      =  do  {b <- bool; return (B b)}`choiceT`
				do  {c <- character; return (C c)}`choiceT`
				do  {f <- float; return (F f)}`choiceT`
				do  {i <- integer; return (I i)}

typE         =  do  {symbolT "int"; return (INT)}`choiceT`
				do  {symbolT "float"; return (FLOAT)}`choiceT`
				do  {symbolT "bool";  return (BOOL)}`choiceT`
				do  {symbolT "char";  return (CHAR)}

bool		 =  do  {symbolT "true"; return (True)}`choiceT`
				do	{symbolT "false"; return (False)}

character    =  do	{c <- letterT; return c}

float        =  do  
					{
					n1 <- numsT;
					symbolT ".";
					n2 <- numsT;
					return (read (n1++"."++n2) :: Float)}

integer      =  do  {n <- numsT; return ((read n) :: Int)}

unOp         =  do  {o <- symbolT "-"; return (Minus)}`choiceT`
				do  {o <- symbolT "!"; return (Not)}

orOp         =  do {symbolT "||"; return
					(\e1 e2 -> Expr (Binary (BoolOp Or)e1 e2))}

andOp        =  do {symbolT "&&"; return
					(\e1 e2 -> Expr (Binary (BoolOp And)e1 e2))}

relOp        =  do {symbolT "=="; return Eq}
				`choiceT`
				do {symbolT "!="; return NotEq}
				`choiceT`
				do {symbolT "<="; return LtEq}
				`choiceT`
				do {symbolT ">="; return GtEq}
				`choiceT`
				do {symbolT "<"; return Lt}
				`choiceT`
				do {symbolT ">"; return Gt}


addOp        =  do {symbolT "+"; return
					(\e1 e2 ->Expr (Binary (ArithOp Add)e1 e2))}
				`choiceT`
				do {symbolT "-"; return
					(\e1 e2 -> Expr (Binary (ArithOp Sub)e1 e2))}

mulOp        =  do {symbolT "*"; return
					(\e1 e2 -> Expr (Binary (ArithOp Mul)e1 e2))}
				`choiceT`
				do {symbolT "/"; return
					(\e1 e2 -> Expr (Binary (ArithOp Div)e1 e2))}

identifier   = do  {
					t <- tokenT identT;
					if (elem t reserved) then failT else
						return t}

reserved = ["bool","else","float","int","true","char","false",
				"if","main","while"]

showit [(a,"")] = display 0 a

clone = "int main ( ) {int a, b, c, d; b = a; b = 5; d = c; c = 7; }"
fact = "int main ( ) { int n, i, f;n = 3;i = 1;f = 1;while (i < n) {i = i + 1;f = f * i; }}"

newt = "int main() {float a, x, result;a = 4.0;x = 1.0;while (x*x > a+0.0001 || x*x < a-0.0001 )x = (x + a/x)/2.0;result = x;}"


fract = "int main ( ) {    int n, i, f;    n = 3;    i = 1;    f = 1;    while (i < n) {        i = i + 1;        f = f * i;    }}"

--execute parser for fact:
--liftM fst$liftM head$liftM fst$runStateT ((parseT program) fact) 1

