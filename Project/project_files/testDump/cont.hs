import Control.Monad.Cont



ex3 = do
  a <- return 1
  b <- cont (\cc -> "escape")
  return $ a+b

t3 = runCont ex3 show



ex2 = do
  a <- return 1
  b <- cont (\cc -> cc 10)
  return $ a+b

t2 = runCont ex2 show


ex4 = do
  a <- return 1
  b <- cont (\cc -> cc 10 ++ cc 20)
  return $ a+b

t4 = runCont ex4 show




ex6 = do
  a <- return 1
  b <- cont (\cc -> cc 10 ++ cc 20)
  return $ a+b

t6 = runCont ex6 (\x -> [x])


ex8 = do
  a <- return 1
  b <- cont (\cc -> [10,20] >>= cc)
  return $ a+b

t8 = runCont ex8 return



nest n = let x = 5 in n + 5






