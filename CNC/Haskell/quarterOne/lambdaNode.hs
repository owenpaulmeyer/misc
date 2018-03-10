

data Addtn  = A Term Os -- Addition -> Term {Op Term}
data Os   = O Op Term Os | Lamb --Os is the unamed node
type Term = Int
data Op   = Add | Sub


eval (A t os) = (eval' os) t

eval' (O op t os)    = (eval' os) . (\a -> (eval'' op) a t)
eval' Lamb          = id

eval'' Add = (+)
eval'' Sub = (-)

term = A 8 (O Sub 6 (O Sub 4 (O Sub 3 Lamb)))


reval (A t os) = apply op t val 
   where 
     (op, val) = oeval os

oeval (O op t Lamb) = (op, t) 
oeval (O op t os) = (op, v') 
   where 
     (op1, v) = oeval os 
     v' = apply op1 t v

apply Sub v1 v2 = v1 - v2 
apply Add v1 v2 = v1 + v2


