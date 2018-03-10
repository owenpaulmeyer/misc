module SetOL (Set,  null, member, empty, fromList, toList, insert, delete) where

import Prelude hiding (null)
import Data.List hiding (null, insert, delete)

newtype Set a = Set [a]

instance Eq a => Eq (Set a) where
	(==) (Set as) (Set bs) = as == bs

instance Show a => Show (Set a) where
	show (Set a) = "fromList " ++ show a

null :: Set a -> Bool
null (Set []) = True
null _        = False

member :: Ord a => a -> Set a -> Bool
member a (Set as) = a `elem` as

empty :: Set a
empty = Set []

fromList :: Ord a => [a] -> Set a
fromList as = Set . remDupSort $ as

toList :: Ord a => Set a -> [a]
toList (Set a) = a

insert :: Ord a => a -> Set a -> Set a
insert e set = fromList . ins e $ (toList set)
	where
		ins _ [] = [e]
		ins e (a:as)
			|e <= a = e:a:as
			|otherwise = a:ins e as

delete :: Ord a => a -> Set a -> Set a
delete e set = fromList . rmv e $ (toList set)
	where
		rmv _ [] = []
		rmv e (a:as)
			|e == a = as
			|otherwise = a:rmv e as


setA = fromList [1..10]
setB = fromList [10,9..1]

remDupSort :: Ord a => [a] -> [a]
remDupSort as = sort . nub $ as
