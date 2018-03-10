import Data.List
import Data.Char
import Test.QuickCheck
infixr 5 >*>

split [] = [([],[])]
split (y:ys) = ([],(y:ys)):[(y:p,q)|(p,q)<-split ys]

subSeq [] = []
subSeq (y:ys) = nub $ [x|(x,xs) <- split (y:ys)]++subSeq ys

subList [] = [[]]
subList (y:ys) = [y:as|as<- subList ys]++subList ys

scalarProd xs ys = sum $ zipWith (*) xs ys
sP xs ys = sum [x*y|(x,y) <- zip xs ys]
test xs ys = scalarProd xs ys == sP xs ys
--quickCheck test
-----------------------------------------------------------------------
-----------------------------------------------------------------------
--parsing/scanning/lexing/lexeming/lemming/...

type Parse a b = [a] -> [(b,[a])]

none :: Parse a b
none inp = []

succeed :: b -> Parse a b
succeed val inp = [(val,inp)]

--preprocessor would be: filter (/= ' ')
whitespace = (\inp -> case list (token ' ') inp of
				[(_,inp)] -> [("",inp)])

tokenspace p = (\inp -> case (whitespace >*> p >*> whitespace) inp of
			[(("",(vals,"")),out)] -> [(vals,out)]
			[] -> []
			_ -> error "whets")


token :: Eq a => a -> Parse a a
token t = spot (==t)

spot :: (a -> Bool) -> Parse a a
spot p (x:xs)
	|p x	= [(x,xs)]
	|otherwise = []
spot p [] = []

alt :: Parse a b -> Parse a b -> Parse a b
alt p1 p2 = (\inp -> p1 inp ++ p2 inp)

--this uses monadic failure propogation:  [] <- [x|x<-[]]
(>*>) :: Parse a b -> Parse a c -> Parse a (b,c)
p1 >*> p2 = (\inp -> [((y,z),rem2)|(y,rem1) <- p1 inp, (z,rem2) <- p2 rem1])

build :: Parse a b -> (b -> c) -> Parse a c
--build p f = (\inp -> [(f x,rem)|(x,rem) <- p inp])
build p f = (\inp -> case p inp of
				[] -> []
				[(x,rem)] -> [(f x,rem)])

list :: Parse a b -> Parse a [b]
list p = (\inp -> [last (list' p inp)])
list' p = (succeed []) `alt` ((p >*> list p) `build` (uncurry (:)))

digList = list (spot isDigit)


neList p = (\inp -> case p inp of
				[] -> []
				_ -> list p inp)

--combines with (>*>) to offer choice
optional :: Parse a b -> Parse a [b]
optional p = (\inp -> case p inp of
				[] -> succeed [] inp
				[(b,as)] -> [([b],as)])

ntimes :: Int -> Parse a b -> Parse a [b]
ntimes 0 _ = succeed []
ntimes n p = (p >*> ntimes (n-1) p) `build` (uncurry (:))



parser :: Parse Char Expr
parser = 	(tokenspace litParse) `alt`
			(tokenspace varParse) `alt` 
			(tokenspace opExpParse)

varParse :: Parse Char Expr
varParse = neList (spot isLower) `build` Var

opExpParse =
	(token '(' >*>
	parser >*>
	spot isOp >*>
	parser >*>
	token ')') `build`
	makeExpr

litParse =
	((optional (token '~')) >*>
	(neList (spot isDigit))) `build`
	(charlistToExpr . uncurry (++))

makeExpr (_,(e1,(bop,(e2,_)))) = Op (charToOp bop) e1 e2

charToOp o
	|o=='+'= Add
	|o=='-'= Sub
	|o=='*'= Mul
	|o=='/'= Div
	|o=='%'= Mod

isOp o
	|o=='+'||o=='-'||o=='*'||o=='/'||o=='%' = True
	|otherwise = False

charlistToExpr [] = Lit 0
charlistToExpr (s:as)
	|s=='~' = Lit (-(read as::Int))
	|otherwise = Lit (read (s:as)::Int)

spotWhile :: (a -> Bool) -> Parse a [a]
spotWhile f = list (spot f)
spotWhile' f = (\inp -> [span f inp])
-------------------------------------------------

data Expr = Op Opers Expr Expr | Var String | Lit Int
data Opers = Add | Sub | Mul | Div | Mod



instance Show Expr where
	show (Lit z) = show z
	show (Op Add e1 e2) = show e1 ++ " + " ++ show e2
	show (Op Sub e1 e2) = show e1 ++ " - " ++ show e2
	show (Op Mul e1 e2) = show e1 ++ " * " ++ show e2
	show (Op Div e1 e2) = show e1 ++ " / " ++ show e2

eval' (Lit a) = fromIntegral a
eval' (Op Add e1 e2) = eval' e1 + eval' e2
eval' (Op Sub e1 e2) = eval' e1 - eval' e2
eval' (Op Mul e1 e2) = eval' e1 * eval' e2
eval' (Op Div e1 (Lit 0)) = error ("div by 0")
eval' (Op Div e1 e2) = eval' e1 `div` eval' e2
eval' (Op Mod e1 e2) = eval' e1 `mod` eval' e2

data Tokens = Opr Char | Sep Char | Val Int | EOS deriving (Show, Eq)

lexer :: Parse Char [Tokens]
lexer = list lexer' where
	lexer' =	(tokenspace valLex) `alt`
				(tokenspace sepLex) `alt`
				(tokenspace opTokLex)

sepLex = spot isSep `build` sepToSep

opTokLex =
	spot isOpr `build` charToOpr

valLex :: Parse Char Tokens
valLex =
	((optional (token '~')) >*>
	(neList (spot isDigit))) `build`
	(charlistToToken . uncurry (++))

charToOpr o
	|o=='+'= Opr o
	|o=='-'= Opr o
	|o=='*'= Opr o
	|o=='/'= Opr o
	|o=='%'= Opr o

sepToSep s = Sep s

isSep s
	|s=='('||s==')' = True
	|otherwise = False

isOpr o
	|o=='+'||o=='-'||o=='*'||o=='/'||o=='%' = True
	|otherwise = False

charlistToToken [] = Val 0
charlistToToken (s:as)
	|s=='~' = Val (-(read as::Int))
	|otherwise = Val (read (s:as)::Int)

--parsit :: [Token] -> Expr
--parsit :: Parse [Tokens] Expr
parsit = 	valParse `alt`
			oprExpParse

oprExpParse =
	(spot izSep >*>
	parsit >*>
	spot izOpr >*>
	parsit >*>
	spot izSep) `build`
	buildExpr

valParse = (spot isVal) `build` (\(Val v) -> Lit v)

buildExpr (_,(e1,(bop,(e2,_)))) = Op (tokenToOp bop) e1 e2

tokenToOp o = case o of
	(Opr '+') -> Add
	(Opr '*') -> Mul
	(Opr '-') -> Sub
	(Opr '/') -> Div

isVal v = case v of
		(Val v) -> True
		_       -> False

izOpr o = case o of
		Opr _ -> True
		_ -> False

izSep (Sep _) = True
izSep _ = False

-------------------------------------------------------------------
-------------------------------------------------------------------

fibs n = take n $ fib

fib = 0:1:(zipWith (+) fib (tail fib))

fact n = take n factorial
factorial = 1:(zipWith (*) factorial [1..])

fract n = take n$scanl' (*) 1 [1..]

infProd :: [a] -> [b] -> [(a,b)]
infProd as bs = zipWith (,) as bs

--pythTrip = [ (x,y,z) |
--					x <- [2..],
--					y <- [x+1..],
--					z <- [y+1..],

powsies = [ 2^n | n <- [0..]]

scanl' f st iList = out where
	out = st:zipWith f iList out

prows n = take n $ scanl' (*) 1 [2,2..]

infMerge (x:xs) (y:ys) = x:y:infMerge xs ys
removeDupsMergeInf as bs = nub $ infMerge as bs


