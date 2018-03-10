module RegularExprs (RegEx, lam, or', conc, lit, star, show) where



data RegEx = 	Lam |
				Or RegEx RegEx |
				Conc RegEx RegEx |
				Literal Char |
				Star RegEx deriving (Eq, Ord)

lam = Lam
or' r1 r2 = Or r1 r2
conc r1 r2 = Conc r1 r2
lit c = Literal c
star r = Star r


instance Show RegEx where
	show = display

display :: RegEx -> String
display Lam = "Lam"
display (Or e1 e2) = "("++display e1 ++ " | " ++ display e2++")"
display (Literal ch) = [ch]
display (Conc e1 e2) = "("++display e1++display e2++")"
display (Star e) = "("++display e++")*"

literals Lam = []
literals (Literal ch) = show ch
literals (Or e1 e2) = literals e1 ++ literals e2
literals (Conc e1 e2) = literals e1 ++ literals e2
literals (Star e) = literals e

match :: RegEx -> String -> Bool
match Lam str = str == ""
match (Literal ch) str = [ch] == str
match (Or e1 e2) str = match e1 str || match e2 str

