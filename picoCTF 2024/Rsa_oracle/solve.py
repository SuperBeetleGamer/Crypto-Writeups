from pwn import *
from Crypto.Util.number import long_to_bytes

r = remote("titan.picoctf.net", 52816)

r.recvuntil(b"E --> encrypt D --> decrypt. ")
r.sendline(b"e")
r.recvuntil(b"length must be less than keysize): ")
r.sendline(b"\x02")
r.recvuntil(b"phertext (m ^ e mod n) ")

enc_2 = int(r.recvline().strip().decode())
#print(enc_2)

enc_pass = 1634668422544022562287275254811184478161245548888973650857381112077711852144181630709254123963471597994127621183174673720047559236204808750789430675058597
r.recvuntil(b"crypt D --> decrypt. ")
r.sendline(b"d")
r.recvuntil(b"xt to decrypt: ")
r.sendline(str(enc_2*enc_pass).encode())

r.recvuntil(b"iphertext as hex (c ^ d mod n): ")
passtimes2 = int(r.recvline().strip().decode(), 16)
password = long_to_bytes(passtimes2//2)
print(password)


# openssl enc -aes-256-cbc -d -in secret.enc