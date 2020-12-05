# Haskell-Caeser-Cipher
A Small piece of Haskell written from one of my labs implementing a Caesar Cipher 

### Encode
Provides the `encode` function which takes an integer key and a string and encodes the string using the cipher.

### Decode
Provides the `decode` function which uses the same key the string was encoded with.

### Crack
You can use the function `crack` to use frequency analysis of characters in the english language to decode a string using the most likley key.

For strings which are too short or contain many infrequently used characters you can use `crackAl` which takes a tolerance value to accept keys with a worse similarity statistic (using the chi squared statistic), meaning the result looks less like the english language, which may find the result.

This returns an array of pairs between the key used and the result of that key. Of course the higher tolerence you use the more strings you will need to look at, think of it as a brute force approach which gives you the top however many likley strings (infact i may later add a function which gives you the x most likley results)

This can also be used using an encoded string and the decoded string to find the key it was encoded with such as;

```map (fst) (filter (\pair -> decodedString == (snd pair)) (crackAll tolerance encodedString))```

#### Examples
Run in GHCi

*encode - decode*
```
>:l cipher.hs
>:t encode
encode :: Int -> String -> String

> encode 11 "Encode me a Haskell"
"Eynzop xp l Hldvpww"

> decode 11 "Eynzop xp l Hldvpww"
"Encode me a Haskell"
```

*decode without key*
For the string "boxing wizards jump quickly" we cannot use crack as it does not follow a common distribution of characters in the english language. However using crack all and a tolerance of 2.2 we can crack it.

```
> crackAll 2.2 (encode 3 "boxing wizards jump quickly")
[(1,"dqzkpi ykbctfu lwor swkemna"),(3,"boxing wizards jump quickly"),(4,"anwhmf vhyzqcr itlo pthbjkx"),(6,"ylufkd tfwxoap grjm nrfzhiv"),(8,"wjsdib rduvmyn ephk lpdxfgt"),(9,"vircha qctulxm dogj kocwefs"),(10,"uhqbgz pbstkwl cnfi jnbvder"),(11,"tgpafy oarsjvk bmeh imaucdq"),(13,"renydw mypqhti zkcf gkysabo"),(15,"pclwbu kwnofrg xiad eiwqyzm"),(17,"najuzs iulmdpe vgyb cguowxk"),(18,"mzityr htklcod ufxa bftnvwj"),(19,"lyhsxq gsjkbnc tewz aesmuvi"),(20,"kxgrwp frijamb sdvy zdrltuh"),(23,"hudotm cofgxjy pasv waoiqre"),(25,"fsbmrk amdevhw nyqt uymgopc")]
>
> "boxing wizards jump quickly" `elem` map (snd) (crackAll 2.2 (encode 3 "boxing wizards jump quickly"))
True
```

*find key with encoded and decoded*
```
> let decodedString = "boxing wizards jump quickly"
> let encodedString = encode 3 decodedString
> map (fst) (filter (\pair -> decodedString == (snd pair)) (crackAll 2.5 encodedString))
[3]
```
Of course in this example i know they key as i used it in line 2, but if you didnt know the key you would input the encoded text instead of using encode to produce the example.



