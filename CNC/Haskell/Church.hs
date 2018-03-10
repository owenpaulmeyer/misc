{-# LANGUAGE RankNTypes #-}
import Control.Applicative


newtype Church = Church { unChurch :: forall a. (a -> a) -> (a -> a) }
--type Church = forall a. (a -> a) -> (a -> a)

iD    = \x -> x
zero  = \f -> iD      --flip const
one   = inc zero       --iD
two   = inc one
three = inc two
four  = inc three


two' :: Church
two'   = Church (\f -> f . f)
three' :: Church
three' = Church (\f -> f . f . f)

true  = \a b -> a
false = \a b -> b

inc   = \n f   -> f . n f
add   = \m n f -> m f . n f
mul   = \m n -> m . n
pow   = \m n -> n m
pre   = \n f x -> n (\g h -> h (g f)) (\u -> x) (\u -> u)
sub   = \m n -> (n pre) m


predChurch = \n -> Church $ 
    \f -> \x -> unChurch n (\g -> \h -> h (g f)) (\u -> x) (\u -> u)

subChurch = \m -> \n -> unChurch n predChurch m

comp f 1 = f
comp f n = f . (comp f (n-1) )


isZero = \n -> n (\x -> false) true

disp n = n succs 0
bool b = b True False

zer = \f x -> x
on  = \f x -> f x
tw  = \f x -> f . f $ x


succs n = n + 1

pair = (\z -> z b a)

a = one
b = two

thr33 = pre . pre . pre








































--loop :: IO [[Char]]
loop = jam <$> getLine <*> (lot <$> loop)

--jam :: [Char] -> [Char] -> [[Char]]
jam  = \inp1 inp2 -> liftA2 (<*)
			(if inp1 == "0" then Just "0" else Nothing)
			(if inp2 == "0" then Just "0" else Nothing)



lot (Just x) = x
lot Nothing  = []





 


