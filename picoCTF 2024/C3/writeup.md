# C3

By: SuperBeetleGamer

This is the Custom Cyclical Cipher!
Enclose the flag in our wrapper for submission. If the flag was "example" you would submit "picoCTF{example}".

## Solve

Source code analysis:
```py
lookup1 = "\n \"#()*+/1:=[]abcdefghijklmnopqrstuvwxyz"
lookup2 = "ABCDEFGHIJKLMNOPQRSTabcdefghijklmnopqrst"

out = ""

prev = 0
for char in chars:
  cur = lookup1.index(char)
  out += lookup2[(cur - prev) % 40]
  prev = cur

sys.stdout.write(out)
```

Each character is being transformed via a lookup table. Just reverse the 2 lookups like so:
```py
lookup1.index(char)
```
becomes
```py
lookup1[cur]
```
and 
```py
lookup2[(cur - prev) % 40]
```
becomes
```py
(lookup2.index(char) + prev) % 40
```

Switch up the previous and current values as well and the solve for the first part should look something like this:
```py
lookup1 = "\n \"#()*+/1:=[]abcdefghijklmnopqrstuvwxyz"
lookup2 = "ABCDEFGHIJKLMNOPQRSTabcdefghijklmnopqrst"

ciphertext = ...

out = ""

prev = 0
for char in ciphertext:
    cur = (lookup2.index(char) + prev) % 40
    out += lookup1[cur]
    prev = cur

print(out)
```

However, there is more after this since this outputs another code segment:
```py
chars = ""
from fileinput import input
for line in input():
    chars += line
b = 1 / 1

for i in range(len(chars)):
    if i == b * b * b:
        print chars[i] #prints
        b += 1 / 1

```

Luckily, we already recovered `chars`!!!. The source code is a string that we chuck back into this script to recover the flag
```py
# Recovered from the script above
chars = out
b = 1 / 1

for i in range(len(chars)):
    if i == b * b * b:
        print(chars[i]) # Monkey patching cuz I'm on python3
        b += 1 / 1
```
Wrap the flag in picoCTF and its good to go!

## Flag
```
picoCTF{adlibs}
```