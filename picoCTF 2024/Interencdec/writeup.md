# Interencdec

By: SuperBeetleGamer

Can you get the real meaning from this file.
```
YidkM0JxZGtwQlRYdHFhR3g2YUhsZmF6TnFlVGwzWVROclh6YzRNalV3YUcxcWZRPT0nCg==
```

## Solve

Notice that it's in base64 and chuck into base64 decode and get:
```
b'd3BqdkpBTXtqaGx6aHlfazNqeTl3YTNrXzc4MjUwaG1qfQ=='
```

Realize that again... this is base64. Get rid of the b' and ' at the ends though and chuck back in base64 decode:
```
wpjvJAM{jhlzhy_k3jy9wa3k_78250hmj}
```

This looks like a ciphered flag. Given past picoCTF's, every year they will have a caesar/vignere cipher challenge. Chuck this into caesar cipher:

## Flag
```
picoCTF{caesar_d3cr9pt3d_78250afc}
```