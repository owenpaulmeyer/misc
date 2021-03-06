data EithEnv a b c = S {runS :: a -> Either b c} 



instance Functor (EithEnv a b) where
	fmap g (S h) = S (\a -> case h a of
				Left x  -> Left x
				Right a' -> Right (g a') )

instance Functor ((->) r) where
	fmap = (.)

instance Functor (Either e) where
	fmap g (Left x) = Left x
	fmap g (Right a) = Right (g a)

smap g (S h) = S (\a -> case h a of
				Left x  -> Left x
				Right a' -> Right (g a') )


snap g (S h) = S (fmap (fmap g) h)


tes = S tas
tas a
	|even a = Left "nope"
	|otherwise = Right a




