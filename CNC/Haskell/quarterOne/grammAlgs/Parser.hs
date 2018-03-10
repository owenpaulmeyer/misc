module Parser where

import Data.Char

infixr 5 +++

class Monad m => MonadZero m where
	zero :: m a

class  MonadZero m => MonadPlus m where
	mplus :: m a -> m a -> m a

instance MonadZero Parser where
	zero = P (\inp -> [])

instance MonadPlus Parser where
	p `mplus` q = P (\inp -> parse p inp ++ parse q inp)

newtype Parser a = P {parse :: String -> [(a,String)]}

instance Functor Parser where
	fmap f p = P (\inp -> case parse p inp of
								[]        -> []
								[(v,out)] -> [(f v,out)] )

fails = P (\inp -> [])

--join :: Monad m => m (m a) -> m a
join p = P (\inp -> case parse p inp of
						[]        -> []
						[(v,out)] -> parse v out)

instance Monad Parser where
	return a = P (\inp -> [(a,inp)])
--	p >>= f  = P (\inp -> concat [parse (f a) inp' | (a,inp') <- parse p inp])
	p >>= f  = join . fmap f $ p

item :: Parser Char
item = P (\inp -> case inp of
					[]     -> []
					(c:cs) -> [(c,cs)])

p1 +++ p2 = P (\inp -> case parse (p1 `mplus` p2) inp of
						[] -> []
						(x:xs) -> [x] )

sat :: (Char -> Bool) -> Parser Char
sat p = do {c <- item; if p c then return c else zero}

char c = sat (c ==)

digit :: Parser Char
digit = sat isDigit

letter :: Parser Char
letter = sat isAlpha

alphanum :: Parser Char
alphanum = sat isAlphaNum

nums = many1 digit

ident      = do {
				l <- letter;
				lns <- many alphanum;
				return (l:lns)
				}

string :: String -> Parser String
string "" = return ""
string (c:cs) = do {char c; string cs; return (c:cs)}

many :: Parser a -> Parser [a]
many p = many1 p +++ return []

many1 :: Parser a -> Parser [a]
many1 p = do {a <- p; as <- many p; return (a:as)}

sepby :: Parser a -> Parser b -> Parser [a]
p `sepby` sep = (p `sepby1` sep) +++ return []

sepby1 :: Parser a -> Parser b -> Parser [a]
p `sepby1` sep = do {
					a <- p;
					as <- many (do {sep; p});
					return (a:as)
					}

chainl :: Parser a -> Parser (a -> a -> a) -> a -> Parser a
chainl p op a = (p `chainl1` op) +++ return a

chainl1 :: Parser a -> Parser (a -> a -> a) -> Parser a
p `chainl1` op = do {a <- p; rest a}
			where
				rest a = (do
							f <- op
							b <- p
							rest (f a b))
						+++ return a


space :: Parser String
space = many (sat isSpace)

token :: Parser a -> Parser a
token p = do {space; a <- p; space; return a}

symbol :: String -> Parser String
symbol cs = token (string cs)

apply :: Parser a -> String -> [(a,String)]
apply p = parse (do {space; p})


----------------------------------------

