import Control.Monad.State
import Control.Monad.Error


type Stat  = String
type Symb  = String
type Out   = String
type Inp   = String
type Track = [(Stat, Symb)]
type Ture  = ErrorT String (StateT (Inp, Track, Out) IO)


analyze inp = evalStateT (runErrorT ture) (inp, [], [])

ture = do
	zeros3
	(inp, t, o) <- get
	put ('0':'0':inp, t, o)
	deltas

deltas = do
	(inp, ts, out) <- get
	if length inp < 4
		then do
			zeros3
			if out == []
				then liftIO $ print "your machine is deterministic"
				else do
					liftIO $ print out
					return ()
		else do
			let (inp', rule) = tW (tail . tail$ inp, []) in do
				put (inp', ts, out)
				delta rule


delta rule = do
	let sep =  splitUp rule in	
		if length sep /= 5
			then throwError "invalid transition rule encoding"
			else case sep of
				(qI:symI:qJ:symJ:dir:[]) -> do
					liftIO $ putStr "delta: "
					liftIO $ print sep
					(inp, ts, out) <- get
					let t = (qI, symI) in if t `elem` ts
						then put (inp, t:ts, "your machine is nonderterministic")
						else put (inp, t:ts, out)
					deltas

zeros3 :: Ture ()
zeros3 = do
	(inp, ts, out) <- get
	if length inp < 3 then throwError "the encoding must end with 3 zeros" else
		case inp of
			(a:b:c:ds) ->
				if a=='0' && b=='0' && c=='0'
					then do
						put (ds, ts, out)
						return ()
					else throwError "the encoding must begin with 3 zeros"

tW ((a:b:cs), ds)
	|a=='0' && b=='0' = (a:b:cs, reverse ds)
	|otherwise        = tW (b:cs, a:ds)



splitUp [] = []
splitUp as = let sp = span (\a -> a /= '0') as in fst sp : 
	let x = snd sp in if null x then [] else splitUp $ tail (snd sp)



{-

analyze "00010111011011101100110101010100110110111011011001110110101101000"
delta: ["1","111","11","111","11"]
delta: ["11","1","1","1","1"]
delta: ["11","11","111","11","11"]
delta: ["111","11","1","11","1"]
"your machine is deterministic"
Right ()


analyze "00010111011011101100110101010100110110111011011001110110101101001011101110101000"
delta: ["1","111","11","111","11"]
delta: ["11","1","1","1","1"]
delta: ["11","11","111","11","11"]
delta: ["111","11","1","11","1"]
delta: ["1","111","111","1","1"]
"your machine is nonderterministic"
Right ()

-}


