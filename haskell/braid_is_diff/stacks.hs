import qualified Data.Map.Strict as Map
import qualified Data.HashSet as Set

type Index = Int
type Key = Index
type Loom = [Index]
type Env = Map.Map Key [Loom]


type Pttrn = [Int]
type Braid = [Pttrn]
type Tracking = [Pttrn]
type Trace = Set.HashSet Pttrn

n = 5
env = initialize
br  = [2]
bks = fetchKeys env br

pattern = [1..n]

transpose :: Pttrn -> Index -> Pttrn
transpose (x1:x2:xs) 1 = x2:x1:xs
transpose (x:xs) n = x:transpose xs (n-1)

flatten :: [Maybe a] -> [a]
flatten [] = []
flatten (Just a:as) = a:flatten as
flatten (Nothing:as) = flatten as


initialize :: Env
initialize = let ps = [4,2,1,3]
             in Map.fromList $ zip ps $ map (\i -> [[i]]) ps

keys :: Index -> [Key]
keys p = [x|x <- [1..n-1], x /= p]

fetch :: Env -> Key -> Maybe [Loom]
fetch = \env -> \key -> Map.lookup key env

fetchKeys :: Env -> Loom -> [Loom]
fetchKeys env lm = concat $ flatten $ map (fetch env) $ keys $ last lm

weave :: Loom -> Braid
weave lm = weave' pattern lm
weave' :: Pttrn -> Loom -> Braid
weave' pt [] = [pt]
weave' pt (idx:idxs) = let p = transpose pt idx in pt : weave' p idxs

vet :: Braid -> Bool
vet br = vet' Set.empty br
vet' :: Trace -> Braid -> Bool
vet' _ [] = True
vet' tr (e:es)
   |Set.member e tr = False
   |otherwise = vet' (Set.insert e tr) es

stack :: Loom -> [Loom] -> [Loom]
stack _ [] = []
stack lm (l:ls)
   |vet swath = composition : stack lm ls
   |otherwise = stack lm ls
   where
     composition = lm ++ l
     swath = weave composition

expand :: Env -> Loom -> [Loom]
expand env loom = stack loom $ fetchKeys env loom

expanse :: Env -> Int -> Loom -> [Loom]
expanse env 1 loom = expand env loom
expanse env n loom = concat $ map (expand env) $ expanse env (n-1) loom

bridge :: Env -> Int -> [Loom] -> [Loom]
bridge env n lms = concat $ map (expanse env n) lms

compose :: (Eq a, Num a) => a -> (b -> b) -> b -> b
compose 1 f = f
compose n f = f . (compose (n-1) f)

depthFirst = head $ expanse env 109 [3]

tier :: Env -> Int -> Env
tier env n = Map.map (bridge env n) env

t2 = tier env 1
t6 = tier t2 2
t24 = tier t6 3

tt = tier env 5

t5 = tier env 3
t20 = tier t5 4

lm = head $ expanse env 108 [3]

fact n = foldr (*) 1 [2..n]

--println ns = map (\n -> do putStr (show n ++ "\n")) ns

count :: Loom -> [(Int, Int)]
count lm = let ones = foldr (\e -> \acc -> case e of 1 -> acc + 1; _ -> acc) 0 lm
               twos = foldr (\e -> \acc -> case e of 2 -> acc + 1; _ -> acc) 0 lm
               thrs = foldr (\e -> \acc -> case e of 3 -> acc + 1; _ -> acc) 0 lm
               fors = foldr (\e -> \acc -> case e of 4 -> acc + 1; _ -> acc) 0 lm
           in [(1,ones),(2,twos),(3,thrs),(4,fors)]


main = do
  putStr $ show depthFirst

