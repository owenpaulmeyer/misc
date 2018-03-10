
add_cps :: Int -> Int -> (Int -> r) -> r
add_cps x y k = k (x + y)

square_cps :: Int -> (Int -> r) -> r
square_cps x k = k (x * x)

pythagoras_cps :: Int -> Int -> (Int -> r) -> r
pythagoras_cps x y k =
 square_cps x $ \x_squared ->
 square_cps y $ \y_squared ->
 add_cps x_squared y_squared $ \sum_of_squares ->
 k sum_of_squares

thrice_cps :: (o -> (o -> r) -> r) -> o -> (o -> r) -> r
thrice_cps f_cps x k =
 f_cps x $ \fx ->
 f_cps fx $ \ffx ->
 f_cps ffx $ \fffx ->
 k fffx

