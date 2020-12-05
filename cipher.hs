import Data.Char

-- Convert chars to ints and back
char2int :: Char -> Int
char2int c = ord c - ord 'a'

int2char :: Int -> Char
int2char n = chr (ord 'a' + n)

-- Get all indicies of a specific element in a list
positions :: Eq a => a -> [a] -> [Int]
positions x xs = [i | (x', i) <- zip xs [0..], x == x']

-- Return the index of all xs in ys
positions' :: Eq a => [a] -> [a] -> [Int]
positions' []     ys = []
positions' (x:xs) ys = positions x ys ++ positions' xs ys 

-- Return the number of lowercase letters in a string
lowers :: String -> Int
lowers xs = length [x | x <- xs, x >= 'a' && x <= 'z']

count :: Char -> String -> Int
count x xs = length [x' | x' <- xs, x == x']

-- Shift Char by a given factor n
shift :: Int -> Char -> Char
shift n c | isLower c = int2char ((char2int c + n) `mod` 26)
          | otherwise = c

-- Encode a string by shifting each character of a string by the shift factor (key)
encode :: Int -> String -> String
encode key s = [shift key c | c  <- s]

-- use negative shift factor to decode
decode :: Int -> String -> String
decode key s = encode (-key) s

-- Frequency analysis for cracking the cipher using chi-squared statistic

--frequencies of characters in the english language
freq :: [Float]
freq =  [8.1, 1.5, 2.8, 4.2, 12.7, 2.2, 2.0, 6.1, 7.0,
         0.2, 0.8, 4.0, 2.4, 6.7, 7.5, 1.9, 0.1, 6.0, 
         6.3, 9.0, 2.8, 1.0, 2.4, 0.2, 2.0, 0.1]

charFreq :: [Float] -> [(Char,Float)]
charFreq fs  = zip ['a'..'z'] fs

percent :: Int -> Int -> Float
percent n m = (fromIntegral n / fromIntegral m) * 100

-- Get frequency of characters in the encoded message
freqEnc :: String -> [Float]
freqEnc s = [percent (count x s) n | x <- ['a' .. 'z']]
    where n = lowers s

-- Statistic returns a value indicating how similar two tables of values are. Smaller = higher correlation
chisqr :: [Float] -> [Float] -> Float
chisqr os es = sum[(o - e)^2 / e | (o,e) <- zip os es]

rotate :: Int -> [a] -> [a]
rotate n xs = drop n xs ++ take n xs

-- Crack Cipher by rotating through each possible shift of the encoded message and finding the lowest chisqr stat
-- Takes an integer tollerance which is a factor >1 for how likley a key is to be accepted
-- a factor of 1 will return the key with the minimum chisqr index
crackKeys :: String -> Float -> [Int]
crackKeys es 1 = positions (minimum chitab) chitab
    where 
        chitab = [chisqr (rotate n freq') freq | n <- [0..25]] -- compare each rotation to the english language freqs
	freq' = freqEnc es -- get frequency of each element in the encoded string 

crackKeys es tol = positions' [k | k <- chitab, k <= min*tol] chitab
    where
        min = minimum chitab
        chitab = [chisqr (rotate n freq') freq | n <- [0..25]] -- compare each rotation to the english language freqs
	freq' = freqEnc es -- get frequency of each element in the encoded string 

-- attempt to decode with most likley key
crack :: String -> String
crack es = decode (head (crackKeys es 1)) es

-- Try all keys with a 1.2 tollerance from the likley key for less common strings
-- Takes a tolerance for including less likley keys
-- Returns used key and string decoded using that key
crackAll :: Float -> String -> [(Int, String)]
crackAll tol es = zip keys (map (\key -> (decode key es)) keys)
    where
        keys = crackKeys es tol

