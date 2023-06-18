# Login
By: SuperBeetleGamer (SBG)

## Description

Are you Genius?

`nc 13.124.113.252 12345`

## Solve

Okay, let's analyze `cryptGenius.py`. First things first let's look at the encrypt/decrypt functions along with the padding.

```py
BS = 16
pad = lambda s: s + (BS - len(s) % BS) * \
                chr(BS - len(s) % BS)
unpad = lambda s: s[:-ord(s[len(s) - 1:])]

def encrypt(raw):
    raw = pad(raw)
    cipher = AES.new(KEY, AES.MODE_ECB)
    return b64encode(cipher.encrypt(raw.encode('utf8')))

def decrypt(enc):
    enc = b64decode(enc)
    cipher = AES.new(KEY, AES.MODE_ECB)
    return unpad(cipher.decrypt(enc)).decode('utf8')
```

Okay so it seems like its just using standard AES ECB encryption/decryption. The padding is pretty mundane too. It uses a padding system where it fills up the block to 16 bytes. The only interesting thing is that when the blocks are already 16 bytes, it'll add an extra block:

`b'\x0f'*16`

But then again, it doesnt cause too many issues. Let's see the main challenge.

```py
input_data = input ("Did you already solve the trick? > ")
try:
    dec = decrypt(input_data)
    if len(dec) == 128 and dec == "6230ee81ac9d7785a16c75b93a89de9cbb9cbb2ddabaaadd035378c36a44eeacb371322575b467a4a3382e3085da281731557dadd5210f21b75e1e9b7e426eb7":
        print (f"flag : {FLAG}")
    else:
        print ("you're still far away")
except:
    print ("you're still far away")
    continue
```

Okay, so it wants us to find an input such that when it decrypts, it'll equal `dec`. 

```py
print ("I'm a crypto genius")    
input_data = input("Do you want to experiment? > ")

if len(input_data) > 20:
    print ("It's still too much...")
else:
    enc = encrypt(input_data)
    print (enc)
```

The good thing is... They give us an encrpytion oracle!!! We can encrypt anything we want up to a length of 20. Since ECB encryption encrypts each block independetly, we split up `dec` into 16 byte blocks and encrypt each one individually. Given that there will be an extra block of padding, we only need to b64decode the output and take the first 16 bytes.

Do that for all 128//2//6 = 4 blocks of the plaintext and we we get a full encrypted version of it. However, when we try to get the flag, we still get an error. What happened? Well, notice that dec is 8 exactly 8 blocks. This means that the padding function will add an extra block on top of it that the unpad function will remove. 

This isnt too hard though. Simply take the last 16 bytes of one of the previous outputs and append it to the total encrypted plaintext. Thus, when it decrypts it should return: 

`6230ee81ac9d7785a16c75b93a89de9cbb9cbb2ddabaaadd035378c36a44eeacb371322575b467a4a3382e3085da281731557dadd5210f21b75e1e9b7e426eb70f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f`

The unpad function will remove the `\x0f` bytes and we are left with:

`6230ee81ac9d7785a16c75b93a89de9cbb9cbb2ddabaaadd035378c36a44eeacb371322575b467a4a3382e3085da281731557dadd5210f21b75e1e9b7e426eb7`

## Flag

I didn't have a solve script for this since I did everything in the terminal. If you need more information for this writeup please let me know.
