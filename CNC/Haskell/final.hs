import Data.Char
import Control.Applicative

newtype State e a = ST {runS :: e -> (a, e) }




instance Functor (State e) where
	fmap f st = ST (\e -> case runS st e of
		(a, e') -> (f a, e') )


instance Applicative (State e) where
	pure a = ST (\e -> (a, e))
	f <*> p = ST (\e -> case runS f e of
		(f', e') -> case runS p e' of
			(a, e'') -> (f' a, e'') )

instance Monad (State e) where
	return a = ST (\e -> (a, e))
	p >>= f  = ST (\e ->
		case runS p e of
			(a, e') -> runS (f a) e')


applyST :: State e a -> e -> (a, e)
applyST = runS


get :: State s s
get = ST (\e -> (e, e) )

put :: s -> State s ()
put st = ST (\e -> ((), st) )

modify f = do
	st <- get
	put (f st)
	return ()

type GcdState = (Int, Int)

gcdST :: State GcdState Int
gcdST = do
	(x, y) <- get
	let rem = (x `mod` y) in
		if (x `mod` y) == 0
			then return y
			else do
				put (y, rem)
				gcdST

gcd' :: Int -> Int -> Int
gcd' x y = fst ( applyST gcdST (x,y) )

----------------------------------------------------------------

data IntOrOp = Dat Int | Op Aop deriving (Eq, Read, Show)
data Aop     = Add | Sub deriving (Eq, Read, Show)

type PfExp = [IntOrOp]


parsePf :: String -> PfExp
parsePf "" = []
parsePf (c:cs) | isSpace c   = parsePf (dropWhile isSpace cs)
parsePf ('+':cs)             = Op Add : parsePf cs
parsePf ('-':cs)             = Op Sub : parsePf cs
parsePf s@(c:cs) | isDigit c = Dat (read lexeme) : parsePf cs'
  where (lexeme, cs')        = span isDigit s
parsePf _                    = error "parsePf: invalid postfix expression"



evalPf :: PfExp -> [Int] -> Int
evalPf [] st          =  head st
evalPf ((Dat n):p) st =  evalPf p (n:st)
evalPf ((Op  op):p) (a:b:st) =  evalPf p (((applyOp op) b a):st)




--evaporate inp = runS eva (runS parp inp, [])

parp = do
	(inp, outp) <- get
	case inp of
		"" -> do
			return $ head outp
		(c:cs) | isSpace c -> do
			put (dropWhile isSpace cs, outp)
			parp
		('+':cs) -> do
			let x = (head outp) + ((head.tail) outp) in
				put (tail inp, x : (tail.tail) outp)
			parp
		('-':cs) -> do
			let x = ((head.tail) outp) - (head outp) in
				put (tail inp, x : (tail.tail) outp)
			parp		
		s@(c:cs) | isDigit c -> do
			let (lex, cs') = span isDigit s in
				put (tail inp, (read lex :: Int) : outp)
			parp








applyOp :: Aop -> Int -> Int -> Int
applyOp Add = (+)
applyOp Sub = (-)

eval inp =  head$fst (runS eva (parsePf inp, []))

eva = do
	(exp, st) <- get
	if exp == []
		then return st
		else case head exp of
			Dat n -> do
				put (tail exp, n:st)
				eva
			Op op -> do
				let ev = (applyOp op) (head (tail st)) (head st) in
					put (tail exp, ev:(tail (tail st)))
				eva
		



