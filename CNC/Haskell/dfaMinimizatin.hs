import Data.Maybe
import Data.List
import Control.Applicative
import Control.Monad.State

type StAte			= Integer
type StAtes			= [StAte]
type StartStAte		= StAte
type FinalStAtes	= [StAte]
type Symbol			= Char
type Moves			= [Move]

data DFA a = DFA
				(StAtes)
				(Moves )
				(StartStAte )
				(FinalStAtes)
					deriving (Eq, Show)

type Move = (StAte, Symbol, StAte)

data DS   = DS (StAte, StAte) D S deriving Eq
type D = Bool
type    S = [(StAte, StAte)]

instance Show DS where
	show (DS xy True  s) = show xy ++ " 1 " ++ show s
	show (DS xy False s) = show xy ++ " 0 " ++ show s



one :: [StAte] -> [DS]
one sts = filtMayb $ putOne <$> sts <*> sts

filtMayb []     = []
filtMayb (a:as) = case a of
	Just a  -> a : filtMayb as
	Nothing -> filtMayb as

putOne st1 st2
	|st1 < st2 = Just (DS (st1, st2) False [])
	|otherwise = Nothing

two :: [DS] -> FinalStAtes -> [DS]
two [] _     = []
two (a:as) f = case a of
	(DS (st1, st2) d s) ->
		if (st1 `elem` f)
			then if (not (st2 `elem` f))
				then (DS (st1, st2) True s) : two as f
				else (DS (st1, st2) d    s) : two as f
			else if (st2 `elem` f)
				then (DS (st1, st2) True s) : two as f
				else (DS (st1, st2) d    s) : two as f



dist :: (Integer, Integer) -> State [DS] ()
dist ab = do
	dss <- get
	case match ab dss of
		Nothing -> return ()
		(Just (DS xy d s)) -> do
			put ((DS xy True s) `onion` dss)
			distS s

match _ [] = Nothing
match (a, b) (re@(DS (x, y) d s):dss)
	|a == x && b == y && d == False = Just re
	|otherwise = match (a, b) dss

distS :: S -> State [DS] ()
distS ss = do
	dss <- get
	distL ss
	return ()

onionD _ [] = []
onionD n@(DS (a, b) _ _) (r@(DS (x, y) _ s):dss)
	|a == x && b == y = (DS (a, b) True s) : dss
	|otherwise        = r : onionD n dss

onion _ [] = []
onion n@(DS (a, b) d s) (r@(DS (x, y) _ _):dss)
	|a == x && b == y = n : dss
	|otherwise        = r : onion n dss
onionL [] l = l
onionL (d:ds) cs = onionL ds (onion d cs) 


distL :: [(Integer, Integer)] -> State [DS] ()
distL [] = return ()
distL (p:ps) = do
	dist p
	distL ps

--setS :: (StAte, StAte) -> State [DS] () 
setS (i, j) (m, n) = do
	dss <- get
	case matchS (m, n) dss of
		Nothing -> return ()
		(Just (DS (a, b) d s)) -> do
			put ((DS (a, b) d (nub((i, j):s))) `onion` dss)

matchS _ [] = Nothing
matchS (a, b) (re@(DS (x, y) d s):dss)
	|a == x && b == y = Just re
	|otherwise = match (a, b) dss

allAs :: Moves -> [(Move, Move)]
allAs ms = filtMayb $ move <$> ms <*> ms
move d@(s1, a, s2) d'@(s1', a', s2')
	|a == a'       = Just (d, d')
	|otherwise     = Nothing

{-
--thr33 :: [DS] -> Moves -> [State [DS] ()]
thr33 mvs = do
	dss <- get
	put	(appD dss <$> dss <*> allAs mvs)
	return ()
-}
--appD :: [DS] -> DS -> (Move, Move) -> Maybe (StAte, StAte)
appD dss (DS (i, j) False s) ((si, a, sm), (sj, a', sn)) = do
	if (si, sj) == (i, j) && ((deOf (sm, sn) dss) || (deOf (sn, sm) dss)) then
		dist (i, j)
	else
		if sm < sn && (i, j) /= (sm, sn)
			then setS (i, j) (sm, sn)
			else 
				if sm > sn && (i, j) /= (sn, sm)
					then setS (i, j) (sn, sm)
					else return ()
appD _ (DS _ True _) _ = return ()

--	|otherwise = Nothing



three mvs = do
	dss <- get
	stateL (\mv -> (stateL (\ds -> appD dss ds mv) dss)) mvs

stateL _ [] = return ()
stateL f (a:as)	= do
	f a
	stateL f as




zeros [] = []
zeros (re@(DS ab d s):dss)
	|d==False  = re : zeros dss
	|otherwise = zeros dss


deOf :: (StAte, StAte) -> [DS] -> Bool
deOf ss ds = and (proc ss <$> ds)
	where
		proc (i, j) (DS (a, b) d s)
			|i == a && j == b = d
			|otherwise = True

--thr33E :: 






midterm = DFA  [0..6]
			   [(0, 'a', 1),
				(0, 'b', 3),
				(1, 'a', 2),
				(1, 'b', 4),
				(2, 'a', 5),
				(2, 'b', 5),
				(3, 'a', 4),
				(3, 'b', 2),
				(4, 'a', 5),
				(4, 'b', 5),
				(5, 'a', 6),
				(5, 'b', 5),
				(6, 'a', 6),
				(6, 'b', 6)]
			   0
			   [1,3,5,6]



samp = [(0, 'a', 1),
		(0, 'b', 3),
		(1, 'a', 2),
		(1, 'b', 4),
		(2, 'a', 5),
		(2, 'b', 5),
		(3, 'a', 4),
		(3, 'b', 2),
		(4, 'a', 5),
		(4, 'b', 5),
		(5, 'a', 6),
		(5, 'b', 5),
		(6, 'a', 6),
		(6, 'b', 6)]




tet = two (one [0..6]) [1,3,5,6]
test = snd$runState (dist (0, 4)) tet






book = [(0, 'a', 1),
		(0, 'b', 4),
		(1, 'a', 2),
		(1, 'b', 3),
		(2, 'a', 7),
		(2, 'b', 7),
		(3, 'a', 7),
		(3, 'b', 3),
		(4, 'a', 5),
		(4, 'b', 6),
		(5, 'a', 7),
		(5, 'b', 7),
		(6, 'a', 7),
		(6, 'b', 6),
		(7, 'a', 7),
		(7, 'b', 7) ]






























{-



--thr33 :: [DS] -> Moves -> [(StAte, StAte)]
thr33 dss mvs = filtMayb $ appD dss <$> dss <*> allAs mvs

--appD :: [DS] -> DS -> (Move, Move) -> Maybe (StAte, StAte)
appD dss' (DS (i, j) d s) ((si, a, sm), (sj, a', sn))
	|si == i && sj == j && (deOf (sm, sn) dss') = Just (i, j)
	|sm < sn && (i, j) /= (sm, sn) = 
	|otherwise = Nothing

deOf :: (StAte, StAte) -> [DS] -> Bool
deOf ss ds = and (proc ss <$> ds)
	where
		proc (i, j) (DS (a, b) d s)
			|i == a && j == b = d
			|otherwise = True
-}

