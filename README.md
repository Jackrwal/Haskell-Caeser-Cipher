# Haskell-Caeser-Cipher
A Small piece of Haskell written from one of my labs implementing a Caesar Cipher 

### Encode
Provides the `encode` function which takes an integer key and a string and encodes the string using the cipher.

### Decode
Provides the `decode` function which uses the same key the string was encoded with.

### Example
Run in GHCi

```
>:l cipher.hs
>:t encode
encode :: Int -> String -> String

> encode 11 "Encode me a Haskell"
"Eynzop xp l Hldvpww"

> decode 11 "Eynzop xp l Hldvpww"
"Encode me a Haskell"
```
