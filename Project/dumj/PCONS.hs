-- Abstract Syntax for PCONS
module PCONS where

import SEC (Oper (Add, Sub, Mul, Div, Mod, Not, Neg, Lt, Gt, Equ))

data Expr = 

		App Expr Expr | Lam Expr | Var Name | Val AVal |

		Let Name Expr Expr | Case Expr [(Expr, Expr)] | Cond Expr Expr Expr |

		UnOp Oper Expr | BinOp Oper Expr Expr |

		CLst [Expr] | Nil | Cdr Expr | Car Expr | Cons Expr Expr |

		Def Name Params Expr | Clo Expr | Rec Expr | TRec Expr | IRec Expr

				deriving (Show, Eq, Ord)

type Name = String
type Params = [Name]

data AVal = AF Float | AI Int | AC Char | AB Bool
		deriving (Show, Eq, Ord)

ts1 = App (Lam (App (Lam (BinOp Add (BinOp Mul (Var "n") (Var "m")) (Var "m"))) (Val$AI 2))) (Val$AI 3)

ts2 = App (Lam (BinOp Add (Val$AI 2) (Var "x"))) (Val$AI 3)

ts3 = App (Lam (BinOp Mul (Var "x") (Val$AI 2)))
	(App (Lam (BinOp Add (Var "x") (Val$AI 2)))
	(App (Lam (App (Lam (BinOp Mul (Var "n") (Var "m"))) (Val$AI 2))) (Val$AI 3)))

ts4 = Cond (BinOp Lt (Val$AI 4) (Val$AI 3)) ts1 ts3

ts5 = Let "t" (Val$AI 2) (Cond (BinOp Lt (Var "t") (Val$AI 3))  ts1 ts3)

ts6 = App (Lam (BinOp Sub (Var "n") (Val$AI 2))) (App (Lam (Car (Var "x"))) ls)

ls = Cons (Val$AI 2) Nil

em = App (Lam (App (Lam (Cons (Var "x") (Var "y"))) (Val$AI 3))) Nil

ts8 = App (Lam (App (Lam (App func (Val$AI 5))) (Val$AI 4))) (Val$AI 3)

func = Def "func" ["x", "y", "z"] (Clo (BinOp Sub (Var "x") (BinOp Sub (Var "y") (Var "z"))))

pfunc = Def "pf" ["x", "y"]
	(TRec (Cond (BinOp Equ (Var "x") (Val$AI 1)) --predicate
	(Var "y") --then
	(App (Rec (Var "pf")) (CLst [(BinOp Sub (Var "x") (Val$AI 1)), (BinOp Mul (Var "x") (Var "y"))]))))

fract = App (Lam (App pfunc (Val$AI 1))) (Val$AI 3)

bin = BinOp Sub (Val$AI 4) (Val$AI 3)


ap' = App (Var "x") (Val$AI 3)



