import Data.List

inters a b = intr (sort a) (sort b)
	where
		intr _ [] = []
		intr [] _ = []
		intr (a : as) (b : bs)
			|a < b = intr as (b : bs)
			|a == b = a : intr as bs
			|otherwise = intr (a : as) bs

