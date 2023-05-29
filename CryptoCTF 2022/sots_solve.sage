from pwn import *

r = remote('05.cr.yp.toc.tf', 37331)

r.recvuntil(b'[Q]uit\n')
r.sendline(b'g')
n = int(r.recvline().split()[-1].decode())

x = two_squares(n)
send = (str(x[0]) + ',' + str(x[1])).encode()
r.recvuntil(b'[Q]uit\n')
r.sendline(b's')
r.recvuntil('here:')
r.sendline(send)
r.interactive()

#CCTF{3Xpr3sS_4z_Th3_sUm_oF_7w0_Squ4rE5!}