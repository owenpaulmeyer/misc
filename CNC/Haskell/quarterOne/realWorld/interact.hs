-- file: ch04/InteractWith.hs
-- Save this in a source file, e.g. Interact.hs

import Control.Monad
import Char
import Data.List
import System.Environment (getArgs)

interactWith function inputFile outputFile = do
  input <- readFile inputFile
  writeFile outputFile (function input)

main = mainWith myFunction
  where mainWith function = do
          args <- getArgs
          case args of
            [input,output] -> interactWith function input output
            _ -> putStrLn "error: exactly two arguments needed"

        -- replace "id" with the name of our function below
        myFunction = num2








------------------------------------------------------


sublist [] _ = True
sublist _ [] = False
sublist (x:xs) (y:ys)
	|x==y = sublist xs ys
	|x/=y = sublist (x:xs) ys

subseq [] _ = True
subseq (_:_) [] = False
subseq xs yy@(y:ys) =  frontseq xs yy || subseq xs ys

frontseq [] _ = True
frontseq (_:_) [] = False
frontseq (x:xs) (y:ys) = (x==y) && frontseq xs ys

getLines = liftM lines . readFile




isVowel x = 
	x=='a'||
	x=='e'||
	x=='i'||
	x=='o'||
	x=='u'||
	x=='A'||
	x=='E'||
	x=='I'||
	x=='O'||
	x=='U'||
	x=='y'||
	x=='Y'

isV x = elem x "aAeEiIoOuUyY"


num1 = liftM (((filter (subseq "tantan")).(map(map toLower)))) $ getLines "linux.words"

num2 =
	unwords.
	(filter  (\x -> length x >= 7).
	filter (\x -> length(filter isVowel x)==1).
	filter (\x -> length(filter (=='s') x)==0).
	filter (\x -> isLower (head x))).
	lines



num3 = liftM
	(filter (\x -> length(filter (=='i') x)==1).
	filter (\x -> length(filter (=='j') x)==1).
	filter (\x -> length(filter (=='t') x)==1).
	filter (\x -> length(filter (=='x') x)==1).
	filter (\x -> isLower (head x)))
	$ getLines "linux.words"

num4 = liftM 
	(((filter (subseq "dinar"))
	.(map(map toLower))))
	$ getLines "linux.words"

num5 = liftM
	(filter (\x -> pairs (x \\ "rate")).
	(((filter (sublist "rate")).
	(map(map toLower)))))
	$ getLines "linux.words"
		where
			pairs (r:s:t:l:[]) = r==s && t==l
			pairs _ = False

num6 = liftM
	(filter (\x -> x!!4==x!!7&&x!!2==x!!8).
	filter (\x -> length x == 9).
	filter (\x -> isUpper (head x)))
	$ getLines "linux.words"

num7 = liftM
	(filter (\x -> (toLower (x!!0))==x!!3&&x!!3==x!!6&&x!!1==x!!5).
	filter (\x -> length x == 7).
	filter (\x -> isUpper (head x)))
	$ getLines "linux.words"


