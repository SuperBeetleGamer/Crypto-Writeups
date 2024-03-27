# Rsa_oracle

By: SuperBeetleGamer

Can you abuse the oracle?
An attacker was able to intercept communications between a bank and a fintech company. They managed to get the message (ciphertext) and the password that was used to encrypt the message.
After some intensive reconassainance they found out that the bank has an oracle that was used to encrypt the password and can be found here `nc titan.picoctf.net 52816`. Decrypt the password and use it to decrypt the message. The oracle can decrypt anything except the password.

## Solve

At a first glance, the `nc` provided gives us an option to encrypt or decrypt RSA.
```
*****************************************
****************THE ORACLE***************
*****************************************
what should we do for you? 
E --> encrypt D --> decrypt. 
```
Entering e allows us to encrypt anything we want, entering d allows us to decrypt anything we want.

From the description, we can gather that the password file given to us is encrypted via this RSA oracle. Also, trying to decrypt the password through the oracle just gives us a
```
Enter text to decrypt: 1634668422544022562287275254811184478161245548888973650857381112077711852144181630709254123963471597994127621183174673720047559236204808750789430675058597
Lol, good try, can't decrypt that for you. Be creative and good luck
```

But, recall that RSA is homomorphic. Given a encryption/decryption oracle and a ciphertext `c`, if decrypting `c` straight up does not work, we can still get the decryption of `2c`. Let's see how this works.

Given a plaintext `m`, the ciphertext would be `c = m^e (mod n)`. Now let's encrypt `2`. `c = 2^e (mod n)` If we multiply these 2 ciphertexts together, we get `c = m^e * 2^e = (2m)^e (mod n)` Now, by chucking this into the decryption oracle, we can recover `2m`.

So to actually solve this challenge, we first encrypt `2` by sending a `b'\x02'` byte via pwntools. 
```py
from pwn import *
from Crypto.Util.number import long_to_bytes

r = remote("titan.picoctf.net", 52816)

r.recvuntil(b"E --> encrypt D --> decrypt. ")
r.sendline(b"e")
r.recvuntil(b"length must be less than keysize): ")
r.sendline(b"\x02")
r.recvuntil(b"phertext (m ^ e mod n) ")

enc_2 = int(r.recvline().strip().decode())
print(enc_2)
```

Then, multiply the encrypted `2` with the encrypted password which should get us something along the lines of `(2*password)^e` which when decrypted would be `2*password`.

```py
enc_pass = ...
r.recvuntil(b"crypt D --> decrypt. ")
r.sendline(b"d")
r.recvuntil(b"xt to decrypt: ")
r.sendline(str(enc_2*enc_pass).encode())

r.recvuntil(b"iphertext as hex (c ^ d mod n): ")
passtimes2 = int(r.recvline().strip().decode(), 16)
password = long_to_bytes(passtimes2//2)
print(password)
```

After recovering the 5 character password and using hint 2:
`openssl enc -aes-256-cbc -d ...`

We just run `openssl enc -aes-256-cbc -d -in secret.enc` to get the flag!
```
enter AES-256-CBC decryption password:
*** WARNING : deprecated key derivation used.
Using -iter or -pbkdf2 would be better.
picoCTF{su((3ss_(r@ck1ng_r3@_4955eb5d}
```

## Flag
```
picoCTF{su((3ss_(r@ck1ng_r3@_4955eb5d}
```