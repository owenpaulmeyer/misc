import RegularExprs
import Data.Maybe
import Data.List



type States a = [a]
type StartState a = a
type FinalState a = a
type Moves a =[Move a]

data Nfa a = NFA
				(States a)
				(Moves a)
				(StartState a)
				(FinalState a)
					deriving (Eq, Show)

data Move a = Move a RegEx a | Emove a a deriving (Eq,Show,Ord)


samp = NFA	[0,1,2,3]
			[	Move 0 (lit 'a') 1,
				Move 1 (lit 'a') 1,
				Move 1 (lit 'a') 2,
				Move 1 (lit 'b') 0,
				Move 2 (lit 'b') 1,
				Move 0 lam 3,
				Move 2 lam 3 ]
			0
			3

samp2 = NFA	[0,1,2,3]
			[	Move 0 (lit 'b') 1,
				Move 0 (lit 'a') 2,
				Move 1 (lit 'a') 2,
				Move 2 (lit 'b') 1,
				Move 1 (lit 'a') 1,
				Move 1 lam 3,
				Move 2 lam 3 ]
			0
			3

samp3 = NFA	[0,1,2,3]
			[	Move 0 (lit 'b') 1,
				Move 0 (lit 'a') 2,
				Move 1 (lit 'a') 2,
				Move 2 (lit 'b') 2,
				Move 1 lam 3,
				Move 2 lam 3 ]
			0
			3

finalA = NFA	[0,2,4,3,1,5]
			[	Move 0 (lit 'a') 1,
				Move 1 (lit 'a') 1,
				Move 1 (lit 'b') 3,
				Move 3 (lit 'a') 1,
				Move 2 (lit 'a') 1,
				Move 2 (lit 'b') 2,
				Move 4 (lit 'b') 2,
				Move 3 (lit 'b') 4,
				Move 1 lam 5,
				Move 2 lam 5,
				Move 3 lam 5,
				Move 4 lam 5 ]
			0
			5

finalB = NFA	[0,1,2,3,4]
			[	Move 0 lam 1,
				Move 1 (lit 'a') 1,
				Move 1 (lit 'a') 2,
				Move 2 (lit 'b') 1,
				Move 2 (lit 'b') 3,
				Move 3 (lit 'b') 2,
				Move 3 (lit 'b') 3,
				Move 1 lam 4,
				Move 2 lam 4 ]
			0
			4

finalC = NFA	[0,1,3,2,4]
			[	Move 0 lam 1,
				Move 1 (lit 'a') 1,
				Move 1 (lit 'a') 2,
				Move 2 (lit 'b') 1,
				Move 2 (lit 'b') 3,
				Move 3 (lit 'b') 2,
				Move 3 (lit 'b') 3,
				Move 3 lam 4,
				Move 2 lam 4 ]
			0
			4

book = NFA	[0,1,2,3,4]
			[	Move 1 (lit 'b') 0,
				Move 3 (lit 'b') 1,
				Move 0 (lit 'a') 3,
				Move 3 (lit 'b') 0,
				Move 2 (lit 'a') 1,
				Move 0 (lit 'a') 2,
				Move 2 (lit 'b') 2 ]
			0
			3



nfaToRe nfa@(NFA sts mvs ss fs)
	|length sts > 2 = nfaToRe $ deleteNode (NFA sts (jsks nfa jks i) ss fs) i
	|otherwise = nfa
		where
			popls = delete ss (delete fs sts)
			jks   = delete i sts
			i     = head popls 

--jsks :: Ord a => Nfa a -> [a] -> a -> [Nfa a]
jsks nfa jks i' = concat $
	[(nfaMoves . iii . ii . i) (j, k, i', nfa)|j <- jks, k <- jks]

--------------------------
test (j,k,i',nfa) = (nfaMoves . iii . ii . i) (j,k,i',nfa)
--------------------------

--helpers:
nfaMoves (NFA _ mvs _ _) = mvs

getLabels :: Eq a => Nfa a -> a -> a -> [RegEx]
getLabels (NFA _ ms _ _) n1 n2 =
		[ r | (Move a r b) <- ms, a==n1 && b==n2]

addMove :: Ord a => Nfa a -> a -> a -> RegEx -> Nfa a
addMove (NFA sts ms ss fs) n1 n2 rex =
	NFA sts (insert move ms) ss fs where move = Move n1 rex n2

i (j, k, i, nfa)
	| w j i nfa /= 0 && w i k nfa /= 0 && w i i nfa == 0 = 
		(j, k, i, addMove nfa j k rex)
	| otherwise = (j, k, i, nfa)
		where rex = (head (getLabels nfa j i)) `conc` (head (getLabels nfa i k))

ii (j, k, i, nfa)
	| w j i nfa /= 0 && w i k nfa /= 0 && w i i nfa /= 0 = 
		(j, k, addMove nfa j k rex )
	| otherwise  = (j, k, nfa)
		where rex =  (head (getLabels nfa j i)) `conc`
			(star (head (getLabels nfa i i))) `conc` (head (getLabels nfa i k))

iii (j, k, nfa@(NFA sts mvs ss fs) ) = NFA sts mvs' ss fs
	where
		jkMoves = getLabels nfa j k
		re
			|jkMoves == [] = Nothing
			|otherwise     = Just (foldIn or' jkMoves)
		mvs'
			|re == Nothing = []
			|otherwise = insert (Move j (fromJust re) k) (deleteMoves mvs j k) 

w :: (Num a, Eq a1) => a1 -> a1 -> Nfa a1 -> a
w n1 n2 (NFA sts mvs ss fs) = sum [check one n1 n2|one <- mvs]
	where check (Move a _ b) n1 n2
			|a==n1 && b==n2 = 1
			|otherwise      = 0

deleteMoves mvs j k = mvs'
	where mvs' = [mv|mv@(Move a1 r a2) <- mvs,
			(a1 /= j && a2 /= k) && (a1 == j || a2 == k)]

deleteNode :: Ord a => Nfa a -> a -> Nfa a
deleteNode (NFA sts mvs ss fs) n = NFA (delete n sts) mvs' ss fs
		where mvs' = [mv|mv@(Move a1 r a2) <- mvs,a1 /= n && a2 /= n]

foldIn f [a] = a
foldIn f (a:as) = a `f` (foldIn f as)
-------------------------------------------------------
data GTree a = Node a [GTree a] deriving Show

instance Functor GTree where
	fmap f (Node a gs) = Node (f a) (map (fmap f) gs)


flattenG (Node a gs) = a: (concat . map flattenG) gs

test0 = Node 0 [test1,test2,test3]

test1 = Node 1 [test2,test4]
test2 = Node 2 [test3]
test3 = Node 3 []
test4 = Node 4 [test2]
{-
instance Show a => Show (GTree a) where
	show (Node a []) = "Node " ++ show a ++ " []"
	show (Node a gs) = "Node " ++ show a ++ " [ " ++ 
				((concat . map show') gs) ++ " ] "
		where show' n = show n ++ ", "

-}


















