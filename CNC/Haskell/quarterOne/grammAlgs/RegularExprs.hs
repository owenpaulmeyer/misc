module RegularExprs (RegExp, show) where



data RegEx = 	Lamb |
				Or RegEx RegEx |
				Then RegEx RegEx |
				Literal Char |
				Star RegEx deriving Eq

instance Show RegEx where
	show = display

display :: RegEx -> String
display Lamb = "Lam"
display (Or e1 e2) = "("++display e1 ++ " | " ++ display e2++")"
display (Literal ch) = show ch
display (Then e1 e2) = "("++display e1++display e2++")"
display (Star e) = "("++display e++")*"

literals Lamb = []
literals (Literal ch) = show ch
literals (Or e1 e2) = literals e1 ++ literals e2
literals (Then e1 e2) = literals e1 ++ literals e2
literals (Star e) = literals e

match :: RegEx -> String -> Bool
match Lamb str = str == ""
match (Literal ch) str = [ch] == str
match (Or e1 e2) str = match e1 str || match e2 str

