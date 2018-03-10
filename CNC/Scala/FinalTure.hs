import Control.Monad.State
import Control.Monad.Error

type Ture = StateT (Int, Int, Int) IO



