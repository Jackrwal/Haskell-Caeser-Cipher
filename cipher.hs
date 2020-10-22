import Data.Char

char2int :: Char -> Int
char2int c = ord c - ord 'a'

int2char :: Int -> Char
int2char n = chr (ord 'a' + n)

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
