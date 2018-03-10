


import Control.Applicative

--final state and empty stack

data PDA = PDA  {
				states ::	[State],
				sigma  ::	[Symbol],
				gamma  ::	[StackSymbol],
				delta  ::	[Delta],
				start  ::	State,
				finals ::	[State]
				}  deriving Show

type Symbol			= Char
type StackSymbol	= Char
type Stack			= [StackSymbol]
type Delta		 	= (Pop, [Push])
type Pop			= (State, Symbol, StackSymbol)
type Push			= (State, StackSymbol)
type Step			= (State, Input, Stack)
type State			= Int
type Input			= String


process :: Input -> PDA -> [[Step]]
process input pda = process' [(start pda, input, [])]  (delta pda)
process' [] _ = []
process' now ds =
	let round = step now ds in
	case round of
		[] -> []
		bs -> bs:process' bs ds

step :: [Step] -> [Delta] -> [Step]
step steps deltas = concat $ applyDelta <$> deltas <*> steps

applyDelta :: Delta -> Step -> [Step]
applyDelta (pop, pushs) step = concat $ transition' (pop,step) <$> pushs

transition :: (Pop, Step) -> Push -> [Step]
transition ((st1, sym, sTs1), (st, inp, stk)) (st2, sTs2) =
	case (push sTs2 st2 . pop sTs1 . symbol sym . state st st1)
			(st, inp, stk) of
		Nothing -> []
		Just x  -> [x]

--filters out rules that apply to other states than this state
state s1 s2 (q, inp, stk)
	|s1 == s2  = Just (q, inp, stk)
	|otherwise = Nothing

symbol _ Nothing = Nothing
symbol a (Just (q, inp, stk))
	--the sequence of these guards is important! because head []
	|a == '#'        = Just (q, inp, stk)
	|inp == ""       = Nothing
	|a == (head inp) = Just (q, tail inp, stk)
	|otherwise       = Nothing

pop _ Nothing = Nothing
pop sTs (Just (q, inp, stk))
	--the sequence of these guards is important! because head []
	|sTs == '#'        = Just (q, inp, stk)
	|stk == ""         = Nothing
	|sTs == (head stk) = Just (q, inp, tail stk)
	|otherwise         = Nothing

push _ _ Nothing = Nothing
push sTs q' (Just (q, inp, stk))
	|sTs == '#' = Just (q', inp, stk)
	|otherwise  = Just (q', inp, sTs:stk)

-------------------------------------------------------------------
--as a continuation:

transition' :: (Pop, Step) -> Push -> [Step]
transition' ((st1, sym, sTs1), (st, inp, stk)) (st2, sTs2) =
	case (state' st st1 (st, inp, stk)) (symbol' sym) (pop' sTs1) (push' sTs2 st2)
			 of
		Nothing -> []
		Just x  -> [x]

state' s1 s2 (q, inp, stk) k
	|s1 == s2  = k$Just (q, inp, stk)
	|otherwise = k$Nothing

symbol' _ Nothing k = k$Nothing
symbol' a (Just (q, inp, stk)) k
	--the sequence of these guards is important! because head []
	|a == '#'        = k$Just (q, inp, stk)
	|inp == ""       = k$Nothing
	|a == (head inp) = k$Just (q, tail inp, stk)
	|otherwise       = k$Nothing

pop' _ Nothing k = k$Nothing
pop' sTs (Just (q, inp, stk)) k
	--the sequence of these guards is important! because head []
	|sTs == '#'        = k$Just (q, inp, stk)
	|stk == ""         = k$Nothing
	|sTs == (head stk) = k$Just (q, inp, tail stk)
	|otherwise         = k$Nothing

push' _ _ Nothing = Nothing
push' sTs q' (Just (q, inp, stk))
	|sTs == '#' = Just (q', inp, stk)
	|otherwise  = Just (q', inp, sTs:stk) 

-------------------------------------------------------------------

samp = PDA {states = [0,1],
			sigma  = ['a','b','#'],
			gamma  = ['A','#'],
			delta  = [	((0,'a','#'),[(0,'A')]),
						((0,'b','A'),[(1,'#')]),
						((1,'b','A'),[(1,'#')]) ],
			start  = 0,
			finals = [0,1]}

sam2 = PDA {states = [0,1,2,3,4],
			sigma  = "ab#",
			gamma  = "ABZ#",
			delta  = [	((0,'#','#'),[(1,'Z')]),
						((1,'b','A'),[(1,'#')]),
						((1,'a','B'),[(1,'#')]),
						((1,'a','A'),[(2,'A')]),
						((1,'a','Z'),[(2,'Z')]),
						((1,'b','B'),[(3,'B')]),
						((1,'b','Z'),[(3,'Z')]),
						((2,'#','#'),[(1,'A')]),
						((3,'#','#'),[(1,'B')]),
						((1,'#','Z'),[(4,'#')])  ],
			start  = 0,
			finals = [4] }



------------------------------------------------------------------

data StepTree a     = ST [StepTree a] | Empty a deriving Show --a is Step


instance Functor StepTree where
	fmap f (Empty a)  = Empty (f a)
	fmap f (ST sts) = ST (map (fmap f) sts)

instance Applicative StepTree where
	pure a = Empty a
	Empty f <*> Empty s = Empty (f s)
	Empty f <*> ST sgs  = ST [Empty f] <*> ST sgs
	ST fgs  <*> Empty s = ST fgs <*> ST [Empty s]
	ST fgs  <*> ST sgs  = ST [f <*> s|f <- fgs, s <- sgs]

stampf = ST [Empty (+1),Empty (+2)]
stamps = ST [ST [Empty 2, Empty 3],Empty 4]




fromList as = ST (map Empty as)


{-
transition' ( (state1, symbol, stackSym1),
							(state, ii@(i:inp), st@(top:stack)) )
								(state2, stackSym2)
			|symbol == '#' =
				if stackSym1 == '#'
					then if stackSym2 == '#'
						then [(state2, ii, st)]
						else [(state2, ii, stackSym2:st)]
					else if stackSym2 == '#'
						then [(state2, ii, stackSym2:stack)]
						else [(state2, ii, stackSym2:stack)]
			|i == symbol =
				if stackSym1 == '#'
					then if stackSym2 == '#'
						then [(state2, inp, st)]
						else [(state2, inp, stackSym2:st)]
					else if stackSym2 == '#'
						then [(state2, inp, stackSym2:stack)]
						else [(state2, inp, stackSym2:stack)]
 			|otherwise = []
-}
comp :: (Applicative f1, Applicative f) =>
     f (f1 (a -> b)) -> f (f1 a) -> f (f1 b)
comp = liftA2 (<*>)
