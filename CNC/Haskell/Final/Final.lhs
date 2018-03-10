-- hsFinal13w-takehome.lhs
-- Individual Work Only


-- Posfix calculator and Monadic postfix calculator

------------------------------------------------------------------------------
-- Fill in the missing code definitions for the two evaluators and calculators.
-- Make sure all the tests give correct answers.
-- Do not change the tests. (But you may add your own tests).
--
-- Due Friday March 8th at 3pm by cnc_submit. Submit with this same filename.
------------------------------------------------------------------------------

-- Runs in two phases - a parsePf phase that produces an
-- internal representation of a postfix expression and then
-- an evalPf phase that evaluates the postfix expression 
-- produced by the parsePf. Uses a Stack module.


-- The Stack module is available on the Final Exam Exercises page for your use.
-- Do not change the Stack module signature.
-- Using the Stack module is optional, but if you don't use it then you
-- must at least supply a Stack type and a makeStack function.

> import Data.Char
> import Stack


------------------------------------------------------------------------------
-- Stack ADT signature

-- makeStack :: Stack t
-- push      :: t -> Stack t -> Stack t
-- top       :: Stack t -> t
-- pop       :: Stack t -> Stack t
-- isEmpty   :: Stack t -> Bool
------------------------------------------------------------------------------

-- The internal representation of a postfix expression

> data IntOrOp = Dat Int | Op Aop deriving (Read, Show)
> data Aop     = Add | Sub deriving (Read, Show)
>
> type PfExpr = [IntOrOp]


-- A simple postfix expression parser

> parsePf :: String -> PfExpr
> parsePf "" = []
> parsePf (c:cs) | isSpace c   = parsePf (dropWhile isSpace cs)
> parsePf ('+':cs)             = Op Add : parsePf cs
> parsePf ('-':cs)             = Op Sub : parsePf cs
> parsePf s@(c:cs) | isDigit c = Dat (read lexeme) : parsePf cs'
>   where (lexeme, cs')        = span isDigit s
> parsePf _                    = error "parsePf: invalid postfix expression"

------------------------------------------------------------------------------
-- A simple postfix expression evaluator
------------------------------------------------------------------------------

> evalPf :: PfExpr -> (Stack Int) -> Int
>
> evalPf [] st           = top st
>
> evalPf ((Dat n) : p) st  = evalPf p (push n st)
>
> evalPf ((Op  op) : p) st =
> 		evalPf p (push (applyOp op ((top . pop) st) (top st)) ((pop . pop) st))
>
>
>
> applyOp :: Aop -> Int -> Int -> Int
> applyOp Add = (+)
> applyOp Sub = (-)


> -- Running the postfix evaluator
> calcPf :: String -> Int
> calcPf s = evalPf (parsePf s) makeStack


------------------------------------------------------------------------------
-- A simple Monadic postfix expression evaluator
------------------------------------------------------------------------------

> newtype State env a = ST { runState :: (env -> (a,env)) }
>
> -- Functor instance
> instance Functor (State env) where
>   fmap f (ST s) = ST $ \env -> let (x, env') = s env   -- s :: env -> (a,env)
>                                in  (f x, env')
>
> -- Monad instance
> instance Monad (State env) where
>   ST s >>= g    = ST $ \env -> let (x, env') = s env
>                                    (ST h) = g x
>                                in h env'
>   return g = ST $ \env -> (g, env)

helpers:

> get :: State s s
> get = ST (\env -> (env, env) )

> put :: s -> State s ()
> put st = ST (\env -> ((), st) )

> modify f = do
> 	st <- get
> 	put (f st)
> 	return ()

> evalPfM :: PfExpr -> (State (Stack Int) Int)
> evalPfM []            = do
> 							popM
> evalPfM ((Dat n):p)   = do
> 							pushM n
> 							evalPfM p
> evalPfM ((Op  op):p)  = do
> 							a <- popM
> 							b <- popM
>							pushM (applyOp op b a)
> 							evalPfM p
>
>
>
> popM :: State (Stack Int) Int
> popM =  do
> 		st <- get
>		modify pop
> 		return (top st)
>
> pushM :: Int -> State (Stack Int) ()
> pushM x = do
> 		modify (push x)
> 		return ()

> -- Running the Monadic postfix evaluator

> calcPfM :: String -> Int
> calcPfM s = fst $ runState (evalPfM (parsePf s)) makeStack

------------------------------------------------------------------------------
-- A simple interactive postfix calculator using an imperative style IO.
------------------------------------------------------------------------------

> main :: IO ()
> main = do putStr "Enter a postfix expression (q to quit): "
>           l <- getLine
>           if l == [] || (head l) == 'q'
>             then return ()
>             else do 
>                     putStr "The Answer is: "
>                     print (calcPf l)
>                     main



------------------------------------------------------------------------------
-- Testing 
------------------------------------------------------------------------------

> -- Parset tests
> tp1 = parsePf "38 4 +"
> tp2 = parsePf "3 43 + 5 -"
> tp3 = parsePf "37 4 5 + -"
> tp4 = parsePf "3 4 50+-"
> tp5 = parsePf "3 4 52+- "
> tp6 = parsePf "19 27 13 +"
> tp7 = parsePf "17 +"
 
> -- Postfix evaluator tests
> te1 = evalPf [Dat 38, Dat 4, Op Add] makeStack
> te2 = evalPf [Dat 3, Dat 43, Op Add, Dat 5, Op Sub] makeStack
> te3 = evalPf [Dat 37, Dat 4, Dat 5, Op Add, Op Sub] makeStack
> te4 = evalPf [Dat 398] makeStack

> -- Postfix calculator tests
> t1 = calcPf "38 4 +"
> t2 = calcPf "3 43 + 5 -"
> t3 = calcPf "37 4 5 + -"
> t4 = calcPf "398"
>
> -- Should fail with appropriate message
> t5 = calcPf " 56  398 "
> t6 = calcPf "19 27 13 +"
> t7 = calcPf "17 +"
 

> -- Monadic postfix evaluator tests
> tem1 = fst $ runState (evalPfM [Dat 38, Dat 4, Op Add]) makeStack
> tem2 = fst $ runState (evalPfM [Dat 3, Dat 43, Op Add, Dat 5, Op Sub]) makeStack
> tem3 = fst $ runState (evalPfM [Dat 37, Dat 4, Dat 5, Op Add, Op Sub]) makeStack
> tem4 = fst $ runState (evalPfM [Dat 398]) makeStack

> -- Monadic postfix calculator tests
> tm1 = calcPfM "38 4 +"
> tm2 = calcPfM "3 43 + 5 -"
> tm3 = calcPfM "37 4 5 + -"
> tm4 = calcPfM "398"

> -- Should fail with appropriate message
> tm5 = calcPfM " 56  398 "
> tm6 = calcPfM "19 27 13 +"
> tm7 = calcPfM "17 +"


> -- Comparison tests
> testalleval = [te1,te2,te3,te4]
> testallevalM = [tem1,tem2,tem3,tem4]
> okeval = testalleval == testallevalM

> testallCalc = [t1,t2,t3,t4]
> testallCalcM = [tm1,tm2,tm3,tm4]
> okcalc = testallCalc == testallCalcM


