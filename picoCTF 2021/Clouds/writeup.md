# Clouds (500 pts)

As a heads up, I am probably the most unqualifed person to do a writeup on this but here goes nothing.

TL;DR
We exploit the nimbus cipher via differential crypanalysis.

## Finding the exploit

As always for finding the exploit we check the hints. 

```Have you heard of differential cryptanalysis?```

This gives us a pretty good starting base on what we would be doing. Since I barely understand what differential cryptanlaysis is in the first place, we won't be going over that. But hey its a starting point.
Doing some research on `differential cryptanalysis` on Wikipedia, we find a list of some common block ciphers. Combining this with the title of the chall `clouds`, I determined this must be the `nimbus cipher`.

## Paper

Luckily for us, someone already broke this encryption system. Yay!
[Paper](https://link.springer.com/content/pdf/10.1007/3-540-45473-X_16.pdf)

Perfect, now all we got to do is just implement it.

## Exploit

The exploit itself was written quite well in the paper.
Let's go over it step by step. 

Furman describes a way to defeat this monstrous encryption system by launching an attack of about ~256 plaintexts.
So first step, the differential: $\Delta$

Not going to lie, I have no clue what a differential but whatever,
The differential used in the paper is: $\Delta = 0\underbrace{1...1}_\text{n-2}0 \text{ where n = 64}$

### Plaintexts
Keeping that in mind, we start creating the plaintexts. Furman creates 4 structures of 32 pairs of plaintexts (~256 total).
This is done by:
```
We randomly choose 32 plaintexts whose least and most significant bits are 0. 
We XOR each of these plaintexts with $\Delta$, and get 32 pairs of plaintexts. 
Then, we build three additional structures by:
1. Complementing the most significant bits of all the plaintexts.
2. Complementing the least significant bits of all the plaintexts.
3. Complementing the most and the least significant bits of all the plaintexts
```

Okay sick, let's code that up. 4 structures of 32 pairs of plaintexts.
```py
from Crypto.Util.number import *
import random

delta = int("0" + "1"*62 + "0", 2)
assert delta == 2 ** 63 - 2

st1, st2, st3, st4 = [], [], [], []

for i in range(32):
	rand = ''.join([str(random.randint(0,1)) for _ in range(62)])

	pt1 = int(''.join(["0" + rand + "0"]), 2)
	pt1_ = pt1 ^ delta
	pt2, pt2_ = pt1 ^ 2**63, pt1_ ^ 2**63
	pt3, pt3_ = pt1 ^ 1, pt1_ ^ 1
	pt4, pt4_ = pt2 ^ 1, pt2_ ^ 1

	st1.append([(b"\x00"*(8-len(long_to_bytes(pt1))) + long_to_bytes(pt1)).hex(), (b"\x00"*(8-len(long_to_bytes(pt1_))) + long_to_bytes(pt1_)).hex()])
	st2.append([(b"\x00"*(8-len(long_to_bytes(pt2))) + long_to_bytes(pt2)).hex(), (b"\x00"*(8-len(long_to_bytes(pt2_))) + long_to_bytes(pt2_)).hex()])
	st3.append([(b"\x00"*(8-len(long_to_bytes(pt3))) + long_to_bytes(pt3)).hex(), (b"\x00"*(8-len(long_to_bytes(pt3_))) + long_to_bytes(pt3_)).hex()])
	st4.append([(b"\x00"*(8-len(long_to_bytes(pt4))) + long_to_bytes(pt4)).hex(), (b"\x00"*(8-len(long_to_bytes(pt4_))) + long_to_bytes(pt4_)).hex()])

plaintexts = [st1, st2, st3, st4]
```

Perfect, first (and probably the easiest) part of the attack done.

### Ciphertexts

After creating the plaintexts, we still need to obtain the corressponding ciphertexts.
This was done sending each plaintext and immediately retreiving it.
The flag was also grabbed at the start.

```py
from pwn import *

r = remote('mercury.picoctf.net', PORT)
r.recvuntil(b"Selection?")
r.sendline(b"2")
r.recvuntil(b"you like to read?")
r.sendline(b"0")
flag = bytes.fromhex(r.recvline().strip().decode())

ciphertexts = []

i = 1
for struct in plaintexts:

	ct_struct = []
	for pair in struct:

		ct_pair = []
		for pt in pair:
			r.recvuntil(b'Selection?')
			r.sendline(b"1")
			r.recvuntil(b"note to encrypt:")
			r.sendline(pt.encode())

			r.recvuntil(b'Selection?')
			r.sendline(b"2")
			r.recvuntil(b"you like to read?")
			r.sendline(str(i).encode())

			ct = bytes.fromhex(r.recvline().strip().decode())
			ct_pair.append(ct)

			i += 1

		ct_struct.append(ct_pair)

	ciphertexts.append(ct_struct)
```

### Cracking the last key

Cracking the first subkey was (what I thought) to be the most confusing part.
Furman first describes a condition to make sure that the ciphertexts had to be qualified in order to used to crack the first key.
This was done by a function called Condition 1:

```py
def condition1(pair):
	a,b = pair
	if (a ^ b) % 4 == 2 and a % 2 == 0 and b % 2 == 0:
		return True
	else:
		return False
```

This allows us to figure out which ciphertext pairs to use in determining the last subkey.
For each pair of the subkey that satisfied the condition, it was used to calculate the subkey.
This was done by solving the equation:

$\Delta \cdot K^{5}_{odd} = C_1 + C_2$

Where $\Delta$ is the differential, $C_1$ and $C_2$ are the ciphertext pairs that satisfy condition 1.

However, since the equation is under modular of 2^64, the inverse of $\Delta$ doesn't exist. Luckily, (by means I do not understand) the inverse() function from pycryptodome was able to do that.
Since there are multiple ciphertext pairs that satisfy condition 1, each subkey was kept and the most common subkey was returned.
Since this is an odd subkey, we do not know the LSB of the actual key. We also don't know the MSB of the actual key.
So, we return all 4 possibilities of the actual key which include the odd-subkey in it.

```py
def crack_subkey(cts):
	match = []
	for struct in cts:
		for pair in struct:
			p = [bytes_to_long(pair[0]), bytes_to_long(pair[1])]
			if condition1(p) == True:
				match.append(p)

	poss = []
	for pair in match:
		c1,c2 = pair
		r_side = c1 + c2
		k_odd_poss = ((r_side//2) * inverse(delta, 2**64)) % 2**64
		poss.append(k_odd_poss)

	k = max(set(poss), key = poss.count)

	return [k, k ^ 1, k ^ 2**63, k ^ 2**63 ^ 1]
```

### Recovering the entire key

Now that we know the last key, or more accurately 4 possibly version of it, we can try each one and hope that one of them is correct.
We can use this known key to partially decrypt each ciphertext and crack the next subkey which returns another 4 possibilies of the next subkey.
This process repeats for 5 rounds creating a total of 1024 possible keys.

Each of the possibly keys were stored which we can then use to test each one. 

```py
possible_keys = []

for key5 in key_5:
	cts5 = part_decrypt_odd(ciphertexts, key5)
	cts5 = part_decrypt(cts5, key5)
	key_4 = crack_subkey(cts5)
	for key4 in key_4:
		cts4 = part_decrypt_odd(cts5, key4)
		cts4 = part_decrypt(cts4, key4)
		key_3 = crack_subkey(cts4)
		for key3 in key_3:
			cts3 = part_decrypt_odd(cts4, key3)
			cts3 = part_decrypt(cts3, key3)
			key_2 = crack_subkey(cts3)
			for key2 in key_2:
				cts2 = part_decrypt_odd(cts3, key2)
				cts2 = part_decrypt(cts2, key2)
				key_1 = crack_subkey(cts2)
				for key1 in key_1:
					possible_keys.append(pad(long_to_bytes(key1)) + pad(long_to_bytes(key2)) + pad(long_to_bytes(key3)) + pad(long_to_bytes(key4)) + pad(long_to_bytes(key5)))
```

To find out which of the possibiltes were the actual key, the plaintexts were encrypted and if they all matched up with the ciphertexts, then the key was deemed correct.

## Flag Recovery

Now that we know the key, we can do a standard decryption and find the flag which wasn't too appealing.

Flag: `89bd63caf70f3c58375571b8a91313bb`




