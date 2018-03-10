module SetUL (Set, null, member, empty, fromList, toList, insert, delete)
	where
import Prelude hiding (null)
import Data.List hiding (null, insert, delete)

newtype Set a = Set [a]

instance Eq a => Eq (Set a) where
	(==) (Set as) (Set bs) = (and [elem a bs|a<-as]) && (and [elem b as|b<-bs])

instance (Ord a, Show a) => Show (Set a) where
	show (Set a) = "fromList " ++ show (sort a)

null :: Set a -> Bool
null (Set []) = True
null _        = False

member :: Ord a => a -> Set a -> Bool
member a (Set as) = a `elem` as

empty :: Set a
empty = Set []

fromList :: Ord a => [a] -> Set a
fromList as = Set as

toList :: Ord a => Set a -> [a]
toList (Set a) = a

insert :: Ord a => a -> Set a -> Set a
insert a (Set as)
	|a `member` (Set as) = Set as
	|otherwise = Set (a:as)

delete :: Ord a => a -> Set a -> Set a
delete e set = fromList . rmv e $ (toList set)
	where
		rmv _ [] = []
		rmv e (a:as)
			|e == a = as
			|otherwise = a:rmv e as


setA = Set [1..10]
setB = Set [10,9..1]
