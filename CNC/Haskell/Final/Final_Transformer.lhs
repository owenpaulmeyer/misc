
Here is a simple transformer version that continues running until the user requests termination with q or enter, and reports invalid expressions.  Distinguishes between unparsable inputs and invalid expressions.

> import Data.Char
> import Stack
> import Control.Monad.State
> import Control.Monad.Error


> data IntOrOp = Dat Int | Op Aop deriving (Eq, Read, Show)
> data Aop     = Add | Sub deriving (Eq, Read, Show)
> type PfExpr = [IntOrOp]

> parsePFE :: String -> PfExpr -> PFE PfExpr
> parsePFE inp out = do
> 	case inp of
> 		""                     -> return $ (reverse out)
> 		(c : cs) | isSpace c   -> parsePFE (dropWhile isSpace cs) out
> 		('+' : cs)             -> parsePFE cs (Op Add : out)
> 		('-' : cs)             -> parsePFE cs (Op Sub : out)
>		s@(c : cs) | isDigit c -> let (lexeme, cs') = span isDigit s in
> 				parsePFE cs' (Dat (read lexeme) : out)
> 		_                      -> throwError "Your input does not parse man!"

> evalPfM :: PfExpr -> PFE Int
> evalPfM []            = do
>							st <- get
>							if isEmpty (pop st)
> 								then popM
> 								else do
> 									liftIO $ putStr "Invalid Expr\n"
> 									return 0
> evalPfM ((Dat n):p)   = do
> 							pushM n
> 							evalPfM p
> evalPfM ((Op  op):p)  = do
> 							st <- get
> 							if len st < 2
> 								then do
> 									liftIO $ putStr "Invalid Expr\n"
> 									return 0
> 								else do
> 									st <- get
> 									a <- popM
> 									b <- popM
>									pushM (applyOp op b a)
> 									evalPfM p

> applyOp :: Aop -> Int -> Int -> Int
> applyOp Add = (+)
> applyOp Sub = (-)

> popM :: PFE Int
> popM =  do
> 		st <- get
>		modify pop
> 		return (top st)

> pushM :: Int -> PFE ()
> pushM x = do
> 		modify (push x)
> 		return ()



---------------------------------------------------------------------------
here's the working calc. Type runpfcalc from the command line.
---------------------------------------------------------------------------

> type PFE = ErrorT String (StateT (Stack Int) IO)
>-- type PFE = StateT (Stack Int) (ErrorT String IO)
> runpfcalc  = runStateT (runErrorT pfcalc) makeStack
>-- runpfcalc = runErrorT (runStateT pfcalc makeStack)

> pfcalc :: PFE PfExpr
> pfcalc = do
> 	liftIO $ putStr "Enter a postfix expression (enter to quit): "
> 	l <- liftIO getLine
>	if l == "q" || l == ""
>		then return []
> 		else do
> 			catchError  (parsePFE l [])
> 				(\a -> do {liftIO (putStr (a++"\n")); pfcalc} )
> 			x <- parsePFE l []
> 			result <- evalPfM x
> 			liftIO $ putStr ("result: " ++ (show result) ++ "\n")
> 			modify (\_ -> makeStack)
> 			pfcalc






