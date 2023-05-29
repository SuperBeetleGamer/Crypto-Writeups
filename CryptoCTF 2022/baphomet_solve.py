from Crypto.Util.number import *
import base64

f = open('flag.enc','rb').read()

key = b''

key += long_to_bytes(f[0] ^ ord('q'))
key += long_to_bytes(f[1] ^ ord('0'))
key += long_to_bytes(f[2] ^ ord('n'))
key += long_to_bytes(f[3] ^ ord('u'))
key += long_to_bytes(f[4] ^ ord('r'))
key += long_to_bytes(f[5] ^ ord('N'))

dec = b''

for a in range(len(f)):
	dec += long_to_bytes(f[a] ^ key[a % len(key)])

dec = dec.decode()

b64_dec = ''
for i in dec:
	if i.islower():
		b64_dec += str(i.upper())
	else:
		b64_dec += str(i.lower())

flag = base64.b64decode(b64_dec)
print(flag.decode())

#CCTF{UpP3r_0R_lOwER_17Z_tH3_Pr0bL3M}