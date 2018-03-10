import Test.QuickCheck

infixr 5 >->


-- problem 26
combs _ [] = []
combs 1 ls = map (:[]) ls
combs n (l:ls) = map (l:) (combs (n-1) ls) ++ (combs n ls)




--------------------------
--assignment 3

unfold p h t x | p x       = []
               | otherwise = h x : unfold p h t (t x)

groupBy' :: Eq a => (a -> a -> Bool) -> [a] -> [[a]]
groupBy' _ [] = []
groupBy' bool t@(x:xs) = [y  |y <- t, bool x y]:groupBy' bool (filter (x/=) xs)

groupByy :: (a -> a -> Bool) -> [a] -> [[a]]
groupByy _ [] = []
groupByy p r@(b:as) = foldr tp [[last r]] (init r)
	where tp a' t@(bs:bss)
			|p a' (head bs) = (a':bs):bss
			|otherwise = [a']:t

groupby :: (a -> a -> Bool) -> [a] -> [[a]]
groupby _ [] = []
groupby p r@(b:as) = reverse . foldl tp [[b]] $ as
	where tp t@(bs:bss) a'
			|p a' (head bs) = (a':bs):bss
			|otherwise = [a']:t


(|>) x list = (x:) . list
(<|) list x = list . (x:)

empty = id

--I K S combinators

k x y = x
s x y z = (x z) (y z)
i x = x


dropWhile' p = foldl (\xs x -> if p x && length xs == 0 then [] else xs ++ [x]) []

--tst :: Eq a => [a] -> Bool

tst as = (dropWhile' (\a->a*a/12 <= 45) as) == (dropWhile (\a->a*a/12 <= 45) as)



------------------------------------------

data Expr =
	Lit Int |
	Expr :+: Expr |
	Expr :-: Expr |
	Expr :*: Expr |
	Expr :/: Expr

size :: Expr -> Int
size (Lit _) = 0
size (e1 :+: e2) = size e1 + size e2 + 1
size (e1 :-: e2) = size e1 + size e2 + 1
size (e1 :*: e2) = size e1 + size e2 + 1
size (e1 :/: e2) = size e1 + size e2 + 1

instance Show Expr where
	show (Lit z) = show z
	show (e1 :+: e2) = show e1 ++ " + " ++ show e2
	show (e1 :-: e2) = show e1 ++ " - " ++ show e2
	show (e1 :*: e2) = show e1 ++ " * " ++ show e2
	show (e1 :/: e2) = show e1 ++ " / " ++ show e2

eval (Lit a) = fromIntegral a
eval (e1 :+: e2) = eval e1 + eval e2
eval (e1 :-: e2) = eval e1 - eval e2
eval (e1 :*: e2) = eval e1 * eval e2
eval (e1 :/: (Lit 0)) = error ("div by 0")
eval (e1 :/: e2) = eval e1 / eval e2


data Exprn =
	Lit' Int |
	Op Opr Exprn Exprn
data Opr = Add | Sub | Mul | Div | Mod

instance Show Exprn where
	show (Lit' z) = show z
	show (Op Add e1 e2) = show e1 ++ " + " ++ show e2
	show (Op Sub e1 e2) = show e1 ++ " - " ++ show e2
	show (Op Mul e1 e2) = show e1 ++ " * " ++ show e2
	show (Op Div e1 e2) = show e1 ++ " / " ++ show e2

eval' (Lit' a) = fromIntegral a
eval' (Op Add e1 e2) = eval' e1 + eval' e2
eval' (Op Sub e1 e2) = eval' e1 - eval' e2
eval' (Op Mul e1 e2) = eval' e1 * eval' e2
eval' (Op Div e1 (Lit' 0)) = error ("div by 0")
eval' (Op Div e1 e2) = eval' e1 / eval' e2
eval' (Op Mod e1 e2) = eval' e1 `mod` eval' e2


data NTree = Null | Node Int NTree NTree

occurs :: Int -> NTree -> Bool
occurs _ Null = False
occurs n (Node i t1 t2)
	|n == i = True
	|otherwise = occurs n t1 || occurs n t2

collapse :: NTree -> [Int]
collapse Null = []
collapse (Node i t1 t2) = collapse t1 ++ [i] ++ collapse t2

sort :: NTree -> [Int]
sort nt = foldT insort nt $ []

insort :: Int -> [Int] -> [Int]
insort a [] = [a]
insort a bb@(b:bs)
		|a < b = a:bb
		|otherwise = b: insort a bs

foldT f  Null = id
foldT f (Node i t1 t2) = (f i) . (foldT f t1) . (foldT f t2)

tree = Node 4 (Node 9 (Node 4 Null (Node 2 Null Null)) Null)  (Node 1 (Node 5 Null (Node 6 Null (Node 5 Null Null))) Null)



takeWhile' :: (a -> Bool) -> [a] -> [a]
takeWhile' p = foldr (\x ys -> if p x then x:ys else []) []

twist :: Either a b -> Either b a
twist a = case a of
		(Right a) -> (Left a)
		(Left  a) -> (Right a)

fun :: Either a b -> Int
fun (Right x) = 0
fun (Left y)  = 1

fan (Right x) = 'a'
fan (Left x ) = 'b'

either' :: (a -> r) -> (b -> r) -> Either a b -> r
either' f g = (\x -> case x of
				(Right x) -> g x
				(Left  x) -> f x )

trans1 :: (a -> b) -> a -> Either b r
trans1 f = (\a -> Left (f a))

trans2 :: (a -> b) -> a -> Either r b
trans2 f = (\a -> Right (f a))

joinE :: (a -> c) -> (b -> d) -> Either a b -> Either c d
joinE f g = either (trans1 f) (trans2 g)

errDiv n m
	|m /= 0 = Just (n `div` m)
	|otherwise = Nothing

errBang n ms
	|n < (length ms) = Just (ms!!n)
	|otherwise           = Nothing

process :: [Int] -> Int -> Int -> Int
process xs n m
	|errBang n xs == Nothing = 0
	|errBang m xs == Nothing = 0
	|otherwise = (xs!!m)+(xs!!n)

squashM Nothing = Nothing
squashM (Just a) = a

compose :: (a -> Maybe b) -> (b -> Maybe c) -> (a -> Maybe c)
compose f g = (\a -> case f a of
				Nothing -> Nothing
				Just a  -> g a )

merb :: Int -> Maybe Bool
merb a
	|a < 0          = Nothing
	|a `mod` 2 == 0 = Just True
	|otherwise      = Just False

birm :: Bool -> Maybe Int
birm a
	|a==True = Just 1
	|otherwise = Nothing



(>->) :: Maybe a -> (a -> Maybe b) -> Maybe b
p >-> f = squashM . fmap f $ p 

data Err a = Ok a | Error String deriving Show

errorT :: String -> Maybe a -> Err a
errorT str a = case a of
	Nothing -> Error str
	Just a  -> Ok a
