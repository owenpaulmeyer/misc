import qualified Data.Map.Strict as Map
import Data.List (permutations)

type Idx = Int
type Pttrn = [Idx]
type Key = Pttrn
type Braid = [Pttrn]
type Env = Map.Map Key Braid

transpose :: Pttrn -> Idx -> Pttrn
transpose (x1:x2:xs) 1 = x2:x1:xs
transpose (x:xs) n = x:transpose xs (n-1)

keys :: Pttrn -> [Key]
keys p = let idxs = [1..(length p - 1)]
         in map (transpose p) idxs

flatten :: [Maybe a] -> [a]
flatten [] = []
flatten (Just a:as) = a:flatten as
flatten (Nothing:as) = flatten as

--braidKeys :: Env -> Braid -> [Braid]
braidKeys env br = concat $ flatten $ map (\key -> Map.lookup key env) $ keys $ last br

initialize :: Int -> Env
initialize n = let ps = permutations [1..n]
               in Map.fromList $ zip ps $ map (\i -> [i]) ps

vet :: Braid -> Braid -> Bool
vet as bs = foldr (&&) True $ map (\a -> elem a bs) as

stack :: Braid -> [Braid] -> [Braid]
stack _ [] = []
stack br (b:bs)
  |vet br b = (br ++ b):stack br bs
  |otherwise = stack br bs

--branch :: Env -> Braid -> [Braid]
branch env braid = stack braid $ braidKeys env braid

main = do
  putStr $ show $ initialize 4
  putStr "\n"
