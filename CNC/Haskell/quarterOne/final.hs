data Tree a = Leaf | Node a (Tree a) (Tree a) deriving (Show, Eq)


foldT f Leaf = id
foldT f (Node a t1 t2) = (f a) . (foldT f t1) . (foldT f t2)

foldT2 f b Leaf = b
foldT2 f b (Node a t1 t2) = f a (foldT2 f b t1) (foldT2 f b t2)

flatten tree = foldT2 (\a b c -> a:(b++c) ) [] tree

flattenF f tree = foldT2 (\a b c -> f a:(b++c) ) [] tree

treep = Node tr (Node tr (Node tr Leaf (Node tr Leaf Leaf)) (Node tr Leaf Leaf)) Leaf

tr = Node 3 (Node 4 (Node 5 Leaf (Node 2 Leaf Leaf)) (Node 6 Leaf Leaf)) Leaf

trp = Node (Just 3) (Node (Just 4) (Node Nothing Leaf (Node (Just 2) Leaf Leaf)) (Node Nothing Leaf Leaf)) Leaf


fltTM Leaf = []
fltTM (Node Nothing t1 t2) = fltTM t1++fltTM t2
fltTM (Node (Just a) t1 t2) = a:fltTM t1++fltTM t2

filcomp :: (a -> Bool) -> [a] -> [a]
filcomp p as = [x|x<-as,p x]

infixl 5 <*>
(<*>) :: [(a -> b)] -> [a] -> [b]
xs <*> ys = zipWith ($) xs ys

itl :: Int -> (a -> a) -> [a] -> [[a]]
itl n f = take n . iterate (map f)




rd :: Eq a => [a] -> [a]
rd []     = []
rd (a:as) = if a `elem` rd as then rd as else a : rd as

redub as = foldr (\a bs -> if a `elem` bs then bs else a:bs) [] as

masf :: (a -> b) -> [a] -> [b]
masf f = foldr ((:) . f) [] 

iritate :: (a -> a) -> a -> [a]
iritate f a = a:iritate f (f a)

iritateL :: Int -> (a -> a) -> [a] -> [[a]]
iritateL n f as = take n $ tate f as where
	tate f as = as:tate f (map f as)


--unfold :: (a -> Bool) -> (a -> a) -> a -> [a]
unfold p f t = map f . takeWhile (not . p) . iterate t

unfool p f t x | p x       = []
               | otherwise = f x : unfool p f t (t x)



data Ex = Val (Maybe Int) | Bin Op Ex Ex

data Op = Mul | Div


--eval Nothing = Nothing
eval (Val (Just n)) = Just n
eval (Bin Div e1 e2) = case eval e1 of
	Nothing -> Nothing
	Just n1 -> case eval e2 of
		Nothing -> Nothing
		Just 0  -> Nothing
		Just n2 -> Just (n1 `div` n2)
eval (Bin Mul e1 e2) = case eval e1 of
	Nothing -> Nothing
	Just n1 -> case eval e2 of
		Nothing -> Nothing
		Just n2 -> Just (n1 * n2)


samp = Bin Div (Val (Just 3)) (Bin Mul (Val (Just 3)) (Val (Just 0)))
