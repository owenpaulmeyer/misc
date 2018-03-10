module Transformers where

import Control.Monad.Identity
import Control.Monad.Error
import Control.Monad.Reader
import Control.Monad.State
import Control.Monad.Writer

import Data.Maybe
import qualified Data.Map as Map






type Name = String

data Exp =	Lit Integer |
			Var Name |
			Plus Exp Exp |
			Abs Name Exp |
			App Exp Exp deriving Show

data Value = IntVal Integer | FunVal Env Name Exp deriving Show

type Env = Map.Map Name Value

exampleExp = (Lit 12 `Plus` (App (Abs "x" (Var "x")) (Lit 4 `Plus` Lit 2))) `Plus`
	(App (Abs "y" (Var "y")) (Lit 4 `Plus` Lit 2))
exEnv = Map.insert "x" (IntVal 3) Map.empty

tick :: (Num s, MonadState s m) => m ()
tick = do {st <- get; put (st+1);}
----------------------------------------------------------
type DubState st1 st2 m a  = StateT st1 (StateT st2 m) a
--dubState
dubb :: DubState Int String Identity (Int,String)
dubb = do
	put 1 --st1
	lift $ (put "1") --st2
	a <- get --st1
	b <- lift get --st2
	return (a,b)

run :: s1 -> s2 -> StateT s1 (StateT s2 Identity) a -> a
run s1 s2 d = runIdentity (evalStateT (evalStateT d s1) s2)


----------------------------------------------------------
type Eval a = ReaderT Env (ErrorT String (WriterT [String]
	(StateT Integer Identity))) a
runEval :: Env -> Integer -> Eval a -> ((Either String a,[String]),Integer)
runEval env st ev =
	runIdentity (runStateT (runWriterT (runErrorT (runReaderT ev env))) st)


--eval :: Exp -> Eval Value
eval (Lit i) =
	do
		tick
		return $ IntVal i
eval (Var n) =
	do
		tick
		tell [n]
		env <- ask
		case Map.lookup n env of
			Nothing -> throwError ("unbound variable: "++ n)
			Just val -> return val
eval (Plus e1 e2) =
	do
		tick
		e1' <- eval e1
		e2' <- eval e2
		case (e1', e2') of
			(IntVal i1, IntVal i2) ->
				return $ IntVal (i1 + i2)
			_ -> throwError "type error in Plus"
eval (Abs n e) =
	do
		tick
		env <- ask
		return $ FunVal env n e
eval (App e1 e2) =
	do
		tick
		val1 <- eval e1
		val2 <- eval e2
		case val1 of
			FunVal env' n body ->
				local (const (Map.insert n val2 env')) (eval body)
			_ -> throwError "type error in App"


{-



type Eval a = ReaderT Env (ErrorT String (WriterT [String]
	(StateT Integer Identity))) a
runEval :: Env -> Integer -> Eval a -> ((Either String a, [String]),Integer)
runEval env st ev =
	runIdentity (runStateT (runWriterT (runErrorT (runReaderT ev env))) st)

eval :: Exp -> Eval Value
eval (Lit i) =
	do
		tick
		return $ IntVal i
eval (Var n) =
	do
		tick
		env <- ask
		case Map.lookup n env of
			Nothing -> throwError ("unbound variable: "++ n)
			Just val -> return val
eval (Plus e1 e2) =
	do
		tick
		e1' <- eval e1
		e2' <- eval e2
		case (e1', e2') of
			(IntVal i1, IntVal i2) ->
				return $ IntVal (i1 + i2)
			_ -> throwError "type error in Plus"
eval (Abs n e) =
	do
		tick
		env <- ask
		return $ FunVal env n e
eval (App e1 e2) =
	do
		tick
		val1 <- eval e1
		val2 <- eval e2
		case val1 of
			FunVal env' n body ->
				local (const (Map.insert n val2 env')) (eval body)
			_ -> throwError "type error in App"




--type Eval a = ReaderT Env (ErrorT String (StateT Integer Identity)) a
type Eval a = ReaderT Env (StateT Integer (ErrorT String Identity)) a
--runEval :: Env -> Integer -> Eval a -> (Either String a, Integer)
--runEval env st ev = runIdentity (runStateT (runErrorT (runReaderT ev env)) st)
runEval :: Env -> Integer -> Eval a -> (Either String (a, Integer))
runEval env st ev = runIdentity (runErrorT (runStateT (runReaderT ev env) st))


tick :: (Num s, MonadState s m) => m ()
tick = do {st <- get; put (st+1);}


eval :: Exp -> Eval Value
eval (Lit i) =
	do
		tick
		return $ IntVal i
eval (Var n) =
	do
		tick
		env <- ask
		case Map.lookup n env of
			Nothing -> throwError ("unbound variable: "++ n)
			Just val -> return val
eval (Plus e1 e2) =
	do
		tick
		e1' <- eval e1
		e2' <- eval e2
		case (e1', e2') of
			(IntVal i1, IntVal i2) ->
				return $ IntVal (i1 + i2)
			_ -> throwError "type error in Plus"
eval (Abs n e) =
	do
		tick
		env <- ask
		return $ FunVal env n e
eval (App e1 e2) =
	do
		tick
		val1 <- eval e1
		val2 <- eval e2
		case val1 of
			FunVal env' n body ->
				local (const (Map.insert n val2 env')) (eval body)
			_ -> throwError "type error in App"



type Eval a =  ErrorT String (ReaderT Env Identity) a
runEval :: Env -> Eval a -> Either String a
runEval env ev = runIdentity (runReaderT (runErrorT ev) env)

eval :: Exp -> Eval Value
eval (Lit i) = return $ IntVal i
eval (Var n) =
	do
		env <- ask
		case Map.lookup n env of
			Nothing -> throwError ("unbound variable: "++ n)
			Just val -> return val
eval (Plus e1 e2) =
	do
		e1' <- eval e1
		e2' <- eval e2
		case (e1', e2') of
			(IntVal i1, IntVal i2) ->
				return $ IntVal (i1 + i2)
			_ -> throwError "type error in Plus"
eval (Abs n e) =
	do
		env <- ask
		return $ FunVal env n e
eval (App e1 e2) =
	do
		val1 <- eval e1
		val2 <- eval e2
		case val1 of
			FunVal env' n body ->
				local (const (Map.insert n val2 env')) (eval body)
			_ -> throwError "type error in App"


type Eval a = ErrorT String Identity a
runEval :: Eval a -> Either String a
runEval ev = runIdentity(runErrorT ev)


eval :: Env -> Exp -> Eval Value
eval env (Lit i) = return $ IntVal i
eval env (Var n) =
	case Map.lookup n env of
		Nothing -> throwError ("unbound variable: "++ n)
		Just val -> return val
eval env (Plus e1 e2) =
	do
		e1' <- eval env e1
		e2' <- eval env e2
		case (e1', e2') of
			(IntVal i1, IntVal i2) ->
				return $ IntVal (i1 + i2)
			_ -> throwError "type error in Plus"
eval env (Abs n e) = return $ FunVal env n e
eval env (App e1 e2) =
	do
		val1 <- eval env e1
		val2 <- eval env e2
		case val1 of
			FunVal env' n body ->
				eval (Map.insert n val2 env') body
			_ -> throwError "type error in App"



type Eval a = Identity a
runEval :: Eval a -> a
runEval ev = runIdentity ev

eval :: Env -> Exp -> Eval Value
eval env (Lit i) = return $ IntVal i
eval env (Var n) = maybe (fail ("undefined variable: "++ n)) return $
	Map.lookup n env
eval env (Plus e1 e2) =
	do
		IntVal i1 <- eval env e1
		IntVal i2 <- eval env e2
		return $ IntVal (i1 + i2)
eval env (Abs n e) = return $ FunVal env n e
eval env (App e1 e2) =
	do
		val1 <- eval env e1
		val2 <- eval env e2
		case val1 of
			FunVal env' n body ->
				eval (Map.insert n val2 env') body

eval0 :: Env -> Exp -> Value
eval0 env (Lit i ) = IntVal i
eval0 env (Var n) = fromJust (Map.lookup n env)
eval0 env (Plus e1 e2 ) =
	let	IntVal i1 = eval0 env e1
		IntVal i2 = eval0 env e2
	in IntVal (i1 + i2 )
eval0 env (Abs n e) = FunVal env n e
eval0 env (App e1 e2 ) =
	let	val1 = eval0 env e1
		val2 = eval0 env e2
	in case val1 of
		FunVal env0 n body ->
			eval0 (Map.insert n val2 env0) body

-}

