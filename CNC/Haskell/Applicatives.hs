import Data.Char
import IO
import System.IO
import System.IO.Error
import Control.Monad
import Data.List
import Control.Applicative --(hiding 

data Ii = Ii
{-
instance Applicative ((->) e) where
	pure x = \e -> x
	ef <*> ex = \e -> (ef e) (ex e)
-}
iI f c cs Ii = pure f <*> c <*> cs

seqq [] = pure []
seqq (c:cs) = iI (:) c rest Ii
	where rest = seqq cs

trans [] = repeat []
trans (xs:xss) = zipWith (:) xs (trans xss )

transe :: Applicative f => [f a] -> f [a]
transe [] = pure []
transe (xs : xss) = iI (:) xs (transe xss) Ii

dist' :: Applicative f => [f a] -> f [a]
dist' [] = pure []
dist' (xs : xss) = iI (:) xs (dist' xss) Ii

class Traversable t where
	traverse :: Applicative f => (a -> f b) -> t a -> f (t b)
	dist :: Applicative f => t (f a) -> f (t a)
	dist = traverse id

instance Traversable [] where
	traverse _ [] = pure []
	traverse f (a:as) = iI (:) (f a) (traverse f as) Ii

data Tree a = Leaf | Node (Tree a) a (Tree a)

instance Functor Tree where
	fmap f Leaf = Leaf
	fmap f (Node l v r) = Node (fmap f l) (f v) (fmap f r)

instance Applicative Tree where
	pure t = Node Leaf t Leaf
	(Node Leaf f Leaf) <*> (Node l v r) = Node (fmap f l) (f v) (fmap f r)
{-
instance Traversable Tree where
	traverse f Leaf = pure Leaf
	traverse f (Node l v r) = pure (Node (traverse f l) (f v)
											(traverse f r) )



instance Applicative Tree where
	pure a = Node Leaf a Leaf
	(Node l1 f l2) <*> (Node 

--traverse' f Leaf = pure Leaf
traverse' f (Node l v r) = pure (Node (traverse' f l) (f v)
											(traverse' f r) )
-}
