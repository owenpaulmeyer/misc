module SECD where

import qualified Data.Map as Map
import Control.Monad.State
import Control.Monad.Error

type Scratch = [Value]
type Env     = [[Value]]
type Code   = [Instr]
type Dump    = [Store]
data Store   = BRT [Instr] | Call (Scratch, Env, Code) deriving Show

type Moment  = (Scratch, Env, Code)

data Value   = I Integer | L [Value] | Cl Closure | B Bool | E Env | Bl Block deriving (Show, Eq)
type Var     = String
type Closure = (Func, Env)
type Const   = Integer
type Block   = [Instr]
type Func    = Block
data Oper    = Add | Sub | Mul | Div | Mod deriving (Show, Eq)
data Rela    = Lt | Gt | Equ deriving (Show, Eq)
data Instr =
			LD Int Int |
			LDC |
			LDF |
			DLY |
			CASE Value |
			DUM |
			STOP |
			CALL |
			LET |
			ENDLET |
			SEL |
			BLI Block | VLI Value | VLS [Value] |
			APP | RAP |
			RTN |
			Op Oper |
			Rel Rela |
			NIL | CONS | CAR | CDR | NULL |
			POP deriving (Eq, Show)
		

{-
instance Show Value where
	show (I i) = show i
	show (L v) = show v
	show (Cl (f, e)) = "Cl ("++show f++",env)"
	show (B b) = show b
-}
delta :: Secd ()
delta = do
	instr <- topC
	(s, e, c) <- get
	case instr of
		LD x y -> do
			let xs = e!!(x-1)
			let v = xs!!(y-1)
			put (v:s, e, c)
		LDC -> do
			VLI v <- topC
			put (v:s, e, c)
		LDF -> do
			BLI f <- topC
			let cl = Cl (f,e)
			put (cl:s, e, c)
		DLY -> do
			BLI c' <- topC
			let dly = Cl (c',e) --using closure structure here for a pattern
			put (dly:s, e, c)
		CASE v -> do
			VLS ptts <- topC
			BLI blks <- topC
			bl <- match v ptts blks
			put (bl:s, e, c)
		DUM -> do
			put (s, []:e, c)
		STOP -> put (s, e, [])
		CALL -> do
			case c == [] of
				True -> do
					Bl c' <- topS
					put (s, e, c')
				False -> do
					Bl c' <- topS
					put (E e:Bl c:s, e, c')
		POP -> popS




match :: Value -> [Value] -> [Instr] -> Secd Value
match _ [] _ = throwError "unmatched pattern in case"
match v (p:ps) (b:bs)
	|p==v = case b of BLI b -> return (Bl b)
	|otherwise = match v ps bs

--rplaca v = case v of
--	Cl (f,n:e) -> [Cl (f,(rplaca v):e)]


--oper :: Oper -> Scratch -> Secd Value
oper op s
	|length s < 2 = throwError "not enough values on stack to operate on"
	|otherwise = case head s of
		I i -> case head (tail s) of
			I i' -> return (appO op i i')
			_    -> throwError "second arg not an int"
		_   -> throwError "first arg not an int"

appO op i i'
	|op == Add = I $ i + i'
	|op == Sub = I $ i - i'
	|op == Mul = I $ i * i'
	|op == Div = I $ i `div` i'
	|op == Mod = I $ i `mod` i'

rela rel s
	|length s < 2 = throwError "not enough values on stack to operate on"
	|otherwise = case head s of
		I i -> case head (tail s) of
			I i' -> return (appR rel i i')
			_    -> throwError "second arg not an int"
		_   -> throwError "first arg not an int"

appR rel i i'
	|rel == Lt = B $ i < i'
	|rel == Gt = B $i > i'
	|rel == Equ = B $ i == i'

--type Secd = ErrorT String (StateT Moment IO)
type Secd = StateT Moment (ErrorT String IO)

run p = runtest ([], [], p)

run' :: Secd ()
run' = do
	(s,e,c)  <- get
	liftIO $ putStrLn ("S: " ++ (show s))
	liftIO $ putStrLn ("E: " ++ (show e))
	liftIO $ putStrLn ("C: " ++ (show c))
	delta
	liftIO $ putStrLn ""
	liftIO $ putStrLn ("Inst: " ++ (show$head c)++" ->")
	secd' <- get
	case secd' of
		(v, e, []) -> do
			liftIO $ putStrLn ("result: "  ++ (show  v))
		secd''         -> run'

displayEnv :: Env -> Secd ()
displayEnv e = do
	if null e
		then do
			liftIO $ putStrLn "   []"
			return ()
		else do
			liftIO $ putStrLn ("   "++(show.head) e)
			displayEnv $tail e
--runtest tp = evalStateT (runErrorT run') tp
runtest tp = runErrorT (evalStateT run' tp)



--Stack operations

pushS :: Value -> Secd ()
pushS v = do
	(s, e, c) <- get
	put (v:s, e, c)
	return ()

popS :: Secd ()
popS = do
	(s, e, c) <- get
	put (tail s, e, c)
	return ()

topS :: Secd Value
topS = do
	(s, e, c) <- get
	put (tail s, e, c)
	return $ head s

topC :: Secd Instr
topC = do
	(s, e, c) <- get
	put (s, e, tail c)
	return $ head c




