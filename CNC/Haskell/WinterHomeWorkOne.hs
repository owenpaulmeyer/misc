import Data.Char
import IO
import System.IO
import System.IO.Error
import Control.Monad
import Data.List


--18.1
--The one above has imperceptably better performance due to tail recursion

--18.2
fmap' :: (a -> b) -> IO a -> IO b
fmap' g io = do
			a <- io
			return (g a)

--18.3
repeat' :: IO Bool -> IO () -> IO ()
repeat' iob io =
	do
		b <- iob
		if (not b) then
			do
				io
				repeat' iob io
			else return ()

iobT = do
	putStr "Please enter int: "
	n <- getInt
	return (odd n)
ioT = do
	putStrLn "that was even"
	return ()


--18.4
while :: (a -> IO Bool) -> (a -> IO a) -> (a -> IO a)
while p f state = do
				b <- p state
				if (b)
					then do
						newState <- f state
						--print a
						while p f newState
					else return state
--call:
--while (\a -> return (a < 10) ) (\a -> return (a+1)) 1


getInt = do
			line <- getLine
			return (read line :: Int)

--18.5
average n = do
			let cond = (\(a, c) -> return (c < n) )
			let bod  = (\(a, c) -> do
				b <- body a
				return (b, c+1) )
			(res, o) <- while cond bod (0, 0)
			return (fromIntegral res / fromIntegral n)

body a = do
		i <- getInt
		return (i + a)

body' a h = do
		i <- hGetLine h
		return ((read i :: Int) + a)

--18.6
fileAverage fileName num = do
	handle <- openFile fileName ReadMode
	avEOF handle num
	hClose handle

avEOF hnd n = do
	let cond = (\(a, c, h) -> do
				eof <- hIsEOF h
				if eof
					then do
						fail "expecting: num, found: EOF"
					else return (c < n) )
	let bod  = (\(a, c, h) -> do
				b <- body' a h
				return (b, c+1, h) )
	(r, c, h) <- while cond bod (0, 0, hnd)
	print (fromIntegral r / fromIntegral n)
	return ()

--18.7
accumulate :: [IO a] -> IO [a]
accumulate [] = return []
accumulate (c:cs) = do
	x <- c
	xs <- accumulate cs
	return (x:xs)

sequence' :: [IO a] -> IO ()
sequence' [] = return ()
sequence' (c:cs) = do
	x <- c
	xs <- sequence' cs
	return ()

seqList :: [a -> IO a] -> a -> IO a
seqList [] d = return d
seqList (b:bs) c = do
	a <- b c
	rest <- seqList bs a
	return rest

--18.8
--see 18.6


--18.17
wc' =
	print "Enter your first line: " >>
	getLine >>= \l ->
	while cond bod [l] >>= \ls ->
	putStr "lineCount: " >>
	print ((length ls) - 1) >>
	putStr "wordCount: " >>
	let wordCount = foldr (\a b -> (length a)+b) 0 (map (\a -> words a) ls)
		in print wordCount >>
	putStr "charCount: " >>
	let charCount = length.concat$ls
		in print charCount >>
	return ()
	where
		cond ls = return ((head ls) /= "")
		bod  ls =
			print "Enter a line (just return to end): " >>
			getLine >>= \l ->
			return (l:ls)

--8.10
palInDrome = do
	p <- getLine
	return (isItAPal p)

isItAPal l = (pp == reverse pp)
	where pp = reverse . map toLower . filter isAlpha $ l

--8.11
sumOfTwo = do
	putStrLn "Hey, gimme a number (Better make it an Int):"
	n1 <- getInt 
	putStrLn "Hey, gimme another number (Better make it an Int):"
	n2 <- getInt
	putStr "Here is your first choice of a number plussed with your next choice of a number.  As if it ain't obvious:  "
	putStrLn (show (n1 + n2))
	return ()

--8.12
putNtimes :: Integer -> String -> IO ()
putNtimes n st = do
	if (n == 0)
		then return ()
		else do
			print st
			putNtimes (n-1) st

--8.13
stupidInane = do
	putStrLn "How many stupid numbers do you wanna enter?"
	let cond (n, c) = return (c>0)
	let bod  (n, c) = do
		putStr "Ok enter an integer:  "
		n1 <- getInt
		return (n+n1, c-1)
	c <- getInt
	(res, c') <- while cond bod (0, c)
	putStr "Here is the sum of those numbers I requested:  "
	return res

--8.14
wc = do
	let cond (ls) = return ((head ls) /= "")
	let bod (ls)= do
		print "Enter a line (just return to end): "
		l <- getLine
		return (l:ls)
	print "Enter your first line: "
	l <- getLine
	ls <- while cond bod [l]
	putStr "lineCount: "
	print ((length ls) - 1)
	putStr "wordCount: "
	let wordCount = foldr (\a b -> (length a)+b) 0 (map (\a -> words a) ls)
		in print wordCount
	putStr "charCount: "
	let charCount = length.concat$ls
		in print charCount
	return ()

--8.15 see 8.10

--8.16
palReader = do
	print "enter sentence to test palindromity: "
	l <- getLine
	if (l == "")
		then return ()
	else do
		let bool = isItAPal l
		if bool
			then print "A fine pal you are."
			else print "Sorry pal, try again."
		palReader

--8.17
intSums = do
	let cond (n,f) = return (f /= 0)
	let bod  (n,f) = do
		putStr "How about it, an Int? (0 to quit): "
		i <- getInt
		return (i+n, i)
	(res,nub) <- while cond bod (0, 1)
	putStr "Here is the sum of those nums: "
	print res
	return ()

--8.18
sortNums = sortNums' []
sortNums' as = do
	putStr "How about it, an Int? (0 to quit): "
	n <- getInt
	if (n==0)
		then do
			putStr "results: "
			print as
			return ()
		else do
			let new = insert n as
			sortNums' new

--8.19
--exhibits the behavior of an imperative while loop
















