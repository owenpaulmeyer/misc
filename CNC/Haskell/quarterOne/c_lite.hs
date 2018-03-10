rd []     = []
rd (a:as) = if a `elem` rd as then as else a : rd as
