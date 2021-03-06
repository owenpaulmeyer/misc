import Parser
import Data.Char
import Control.Monad
import Data.List

--type Grammar = Set RuleSet
type RuleSet = [Rule]
type Rule = (Variable , Sequence)
data Variable = Start | Var Char deriving (Eq, Ord)
data Term = Term Char | Lambda deriving (Eq, Ord)
type Sequence = [EandV]
data EandV    = T Term | V Variable deriving (Eq, Ord)


display (v,s) = show v++" -> "++disp s 
instance Show Variable where
	show (Var v) = [v]
	show Start = "S"
instance Show Term where
	show (Term c) = [c]
	show Lambda = "Lambda"
instance Show EandV where
	show (T t) = show t
	show (V v) = show v

disp [] = ""
disp (s:ss) = show s++disp ss 
-----------------------------------------------------------
--nullable transform
transform :: RuleSet -> RuleSet
transform g = sort $ [(v,r)|(v,es) <- g,r <- results es g,r /= [],es /= [T Lambda]]
	++if (V Start ) `elem` nullables g then [(Start,[T Lambda])] else []

nullablePositions :: RuleSet -> Sequence -> [Int]
nullablePositions g es = nullies es 0
	where
		nullies [] _ = []
		nullies (e:es) n
			|elem e nullys = n:nullies es (n+1)
			|otherwise     = nullies es (n+1)
			where nullys =  nullables $ g

substitutions :: Sequence -> [Int] -> Sequence
substitutions es ns = subs es ns 0 where
--	subs [] _ _ = []
	subs e [] _ = e
	subs (e:es) (n:ns) b
		|n==b = subs es ns (b+1)
		|otherwise = e: subs es (n:ns) (b+1)

results :: Sequence -> RuleSet -> [Sequence]
results es g = nub[substitutions e n|e <- [es],n <- powS nellfo]
	where nellfo = nullablePositions g es


results' :: Sequence -> RuleSet -> [Sequence]
results' eNv g = [ev`minus`nb|ev <- [eNv], nb <- [0..length eNv-1], ev!!nb `elem` nlls ]
	where nlls = nullables g




nullables :: RuleSet -> [EandV]
nullables rs = nulls (lambs rs)
	where nulls prevs
		|prevs==new = new
		|otherwise = nulls new
			where
			new = nub$[V v|(v,vs) <- rs, vs `sul` prevs]++prevs

lambs :: RuleSet -> [EandV]
lambs [] = []
lambs (r:rs) = case r of
				(v , seq) -> if elem (T Lambda) seq
					then V v: lambs rs
					else lambs rs
------------------------------------------------------------------
--chain rule transform




chainsOf :: EandV -> RuleSet -> [EandV]
chainsOf v g = nub $ chains [v] []
	where
	chains ch prv = case eqList ch prv of
		1 -> ch
		0 -> chains (ch ++ found) ch
			where found = find (ch \\ prv)
				where find new = [(V (Var a))|(V var') <- new, (var ,[(V (Var a))]) <- g,var'==var]

eqList xs ys = if (and [elem x ys|x<-xs]) && (and [elem y xs|y<-ys]) then 1 else 0
eqL xs ys = xs\\ys==[]&&ys\\xs==[]
--------------------------------------------------------------------

anyelem xs ys = or [x `elem` ys|x<-xs]

sul :: Eq a => [a] -> [a] -> Bool
sul xs ys = and [elem x ys|x <- xs]

powS = filterM (const [False,True])

sans :: Eq t => [t] -> [t] -> [t]
sans xs ys = [x | x <- xs, not (elem x ys)]

less :: Eq a => [a] -> a -> [a]
less xs y = [x|x<-xs, x /= y]

minus :: Num a => [t] -> a -> [t]
minus (x:xs) n
	|n==0 = xs
	|otherwise = x:minus xs (n-1)

fromJust (Just a) = a
fail' = (\any -> [])
-----------------------------------------------------------
--parses strings into rules and grammar

grammar =
	do {
		rs <- many1 rule;
		return rs}

rule =
	do {
		v <- variable;
		arrow;
		s <- token sequ;
		symbol ";";
		return (v,s)}

variable =
	do {
		s <- symbol "S";
		return Start}+++
	do {
		v <- sat isUpper;
		return (Var v)}

arrow = do {symbol "->"; return ""}

sequ = many1 ev
ev =
	do {
		t <- term;
		return (T t)}+++
	do {
		v <- variable;
		return (V v)}

term =
	do {
		l <- symbol "Lambda";
		return Lambda}+++
	do {
		t <- sat isLower;
		return (Term t)}

---------------------------------------------------------------------------

g11 = "S -> ACA; A -> aAa; A -> B; A -> C; B -> bB; B -> b; C -> Cc; C -> Lambda;"
g1 = fst . head $ parse grammar g11

g12 = "S -> ACAa; A -> aAa; A -> B; A -> C; B -> bB; B -> b; C -> Cc; C -> Lambda; C -> AB; "
g2 = fst . head $ parse grammar g12

samp = [(V (Var 'A')),(V (Var 'C')),(V (Var 'A'))]
samp2 = [(T (Term 'a')),(V (Var 'C')),(T (Term 'a'))]

g3a = "S -> ABC; A -> aA; A -> Lambda; B -> bB; B -> Lambda; C -> cC; C -> Lambda;"
g3 = fst . head $ parse grammar g3a

g44 = "S -> aS;S -> bS; S -> B; B -> bb; B -> C; B -> Lambda; C -> cC; C -> Lambda;"
g4 = fst . head $ parse grammar g44


fin = "S -> AB;S -> BCS; A -> aA;A -> C;B -> bbB;B -> b;C -> cC; C -> Lambda;"

--get the transformfrom:
--transform $fst.head$parse grammar fin

finn = "S->A;S->CB;A->C;A->D;B->bB;B->b;C->cC;C->c;D->dD;D->d;"

