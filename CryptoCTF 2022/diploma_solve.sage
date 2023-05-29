from pwn import *

r = remote('08.cr.yp.toc.tf', 37313)

r.recvuntil(b'wait...\n')
r.recvline()

p = 127

def r1():
	l1 = r.recvline().replace(b'[',b'').replace(b']',b'').strip().split()
	l2 = r.recvline().replace(b'[',b'').replace(b']',b'').strip().split()
	l3 = r.recvline().replace(b'[',b'').replace(b']',b'').strip().split()

	line1 = []
	line2 = []
	line3 = []
	for i in l1:
		line1.append(int(i.decode().strip()))
	for i in l2:
		line2.append(int(i.decode().strip()))
	for i in l3:
		line3.append(int(i.decode().strip()))

	mat = Matrix(GF(p), [line1,line2,line3])
	order = mat.multiplicative_order()

	r.recvuntil(b'matrix M:')

	r.sendline(str(order).encode())

	r.recvuntil(b'wait...\n')
	r.recvline()
def r2():
	l1 = r.recvline().replace(b'[',b'').replace(b']',b'').strip().split()
	l2 = r.recvline().replace(b'[',b'').replace(b']',b'').strip().split()
	l3 = r.recvline().replace(b'[',b'').replace(b']',b'').strip().split()
	l4 = r.recvline().replace(b'[',b'').replace(b']',b'').strip().split()

	line1 = []
	line2 = []
	line3 = []
	line4 = []
	for i in l1:
		line1.append(int(i.decode().strip()))
	for i in l2:
		line2.append(int(i.decode().strip()))
	for i in l3:
		line3.append(int(i.decode().strip()))
	for i in l4:
		line4.append(int(i.decode().strip()))

	mat = Matrix(GF(p), [line1,line2,line3,line4])
	order = mat.multiplicative_order()

	r.recvuntil(b'matrix M:')

	r.sendline(str(order).encode())
	r.recvuntil(b'wait...\n')
	r.recvline()
def r3():
	l1 = r.recvline().replace(b'[',b'').replace(b']',b'').strip().split()
	l2 = r.recvline().replace(b'[',b'').replace(b']',b'').strip().split()
	l3 = r.recvline().replace(b'[',b'').replace(b']',b'').strip().split()
	l4 = r.recvline().replace(b'[',b'').replace(b']',b'').strip().split()
	l5 = r.recvline().replace(b'[',b'').replace(b']',b'').strip().split()

	line1 = []
	line2 = []
	line3 = []
	line4 = []
	line5 = []
	for i in l1:
		line1.append(int(i.decode().strip()))
	for i in l2:
		line2.append(int(i.decode().strip()))
	for i in l3:
		line3.append(int(i.decode().strip()))
	for i in l4:
		line4.append(int(i.decode().strip()))
	for i in l5:
		line5.append(int(i.decode().strip()))

	mat = Matrix(GF(p), [line1,line2,line3,line4,line5])
	order = mat.multiplicative_order()

	r.recvuntil(b'matrix M:')

	r.sendline(str(order).encode())
	r.recvuntil(b'wait...\n')
	r.recvline()
def r4():
	l1 = r.recvline().replace(b'[',b'').replace(b']',b'').strip().split()
	l2 = r.recvline().replace(b'[',b'').replace(b']',b'').strip().split()
	l3 = r.recvline().replace(b'[',b'').replace(b']',b'').strip().split()
	l4 = r.recvline().replace(b'[',b'').replace(b']',b'').strip().split()
	l5 = r.recvline().replace(b'[',b'').replace(b']',b'').strip().split()
	l6 = r.recvline().replace(b'[',b'').replace(b']',b'').strip().split()

	line1 = []
	line2 = []
	line3 = []
	line4 = []
	line5 = []
	line6 = []
	for i in l1:
		line1.append(int(i.decode().strip()))
	for i in l2:
		line2.append(int(i.decode().strip()))
	for i in l3:
		line3.append(int(i.decode().strip()))
	for i in l4:
		line4.append(int(i.decode().strip()))
	for i in l5:
		line5.append(int(i.decode().strip()))
	for i in l6:
		line6.append(int(i.decode().strip()))

	mat = Matrix(GF(p), [line1,line2,line3,line4,line5,line6])
	order = mat.multiplicative_order()

	r.recvuntil(b'matrix M:')

	r.sendline(str(order).encode())
	r.recvuntil(b'wait...\n')
	r.recvline()
def r5():
	l1 = r.recvline().replace(b'[',b'').replace(b']',b'').strip().split()
	l2 = r.recvline().replace(b'[',b'').replace(b']',b'').strip().split()
	l3 = r.recvline().replace(b'[',b'').replace(b']',b'').strip().split()
	l4 = r.recvline().replace(b'[',b'').replace(b']',b'').strip().split()
	l5 = r.recvline().replace(b'[',b'').replace(b']',b'').strip().split()
	l6 = r.recvline().replace(b'[',b'').replace(b']',b'').strip().split()
	l7 = r.recvline().replace(b'[',b'').replace(b']',b'').strip().split()

	line1 = []
	line2 = []
	line3 = []
	line4 = []
	line5 = []
	line6 = []
	line7 = []
	for i in l1:
		line1.append(int(i.decode().strip()))
	for i in l2:
		line2.append(int(i.decode().strip()))
	for i in l3:
		line3.append(int(i.decode().strip()))
	for i in l4:
		line4.append(int(i.decode().strip()))
	for i in l5:
		line5.append(int(i.decode().strip()))
	for i in l6:
		line6.append(int(i.decode().strip()))
	for i in l7:
		line7.append(int(i.decode().strip()))

	mat = Matrix(GF(p), [line1,line2,line3,line4,line5,line6,line7])
	order = mat.multiplicative_order()

	r.recvuntil(b'matrix M:')

	r.sendline(str(order).encode())
	r.recvuntil(b'wait...\n')
	r.recvline()
def r6():
	l1 = r.recvline().replace(b'[',b'').replace(b']',b'').strip().split()
	l2 = r.recvline().replace(b'[',b'').replace(b']',b'').strip().split()
	l3 = r.recvline().replace(b'[',b'').replace(b']',b'').strip().split()
	l4 = r.recvline().replace(b'[',b'').replace(b']',b'').strip().split()
	l5 = r.recvline().replace(b'[',b'').replace(b']',b'').strip().split()
	l6 = r.recvline().replace(b'[',b'').replace(b']',b'').strip().split()
	l7 = r.recvline().replace(b'[',b'').replace(b']',b'').strip().split()
	l8 = r.recvline().replace(b'[',b'').replace(b']',b'').strip().split()

	line1 = []
	line2 = []
	line3 = []
	line4 = []
	line5 = []
	line6 = []
	line7 = []
	line8 = []
	for i in l1:
		line1.append(int(i.decode().strip()))
	for i in l2:
		line2.append(int(i.decode().strip()))
	for i in l3:
		line3.append(int(i.decode().strip()))
	for i in l4:
		line4.append(int(i.decode().strip()))
	for i in l5:
		line5.append(int(i.decode().strip()))
	for i in l6:
		line6.append(int(i.decode().strip()))
	for i in l7:
		line7.append(int(i.decode().strip()))
	for i in l8:
		line8.append(int(i.decode().strip()))

	mat = Matrix(GF(p), [line1,line2,line3,line4,line5,line6,line7,line8])
	order = mat.multiplicative_order()

	r.recvuntil(b'matrix M:')

	r.sendline(str(order).encode())
	r.recvuntil(b'wait...\n')
	r.recvline()
def r7():
	l1 = r.recvline().replace(b'[',b'').replace(b']',b'').strip().split()
	l2 = r.recvline().replace(b'[',b'').replace(b']',b'').strip().split()
	l3 = r.recvline().replace(b'[',b'').replace(b']',b'').strip().split()
	l4 = r.recvline().replace(b'[',b'').replace(b']',b'').strip().split()
	l5 = r.recvline().replace(b'[',b'').replace(b']',b'').strip().split()
	l6 = r.recvline().replace(b'[',b'').replace(b']',b'').strip().split()
	l7 = r.recvline().replace(b'[',b'').replace(b']',b'').strip().split()
	l8 = r.recvline().replace(b'[',b'').replace(b']',b'').strip().split()
	l9 = r.recvline().replace(b'[',b'').replace(b']',b'').strip().split()

	line1 = []
	line2 = []
	line3 = []
	line4 = []
	line5 = []
	line6 = []
	line7 = []
	line8 = []
	line9 = []
	for i in l1:
		line1.append(int(i.decode().strip()))
	for i in l2:
		line2.append(int(i.decode().strip()))
	for i in l3:
		line3.append(int(i.decode().strip()))
	for i in l4:
		line4.append(int(i.decode().strip()))
	for i in l5:
		line5.append(int(i.decode().strip()))
	for i in l6:
		line6.append(int(i.decode().strip()))
	for i in l7:
		line7.append(int(i.decode().strip()))
	for i in l8:
		line8.append(int(i.decode().strip()))
	for i in l9:
		line9.append(int(i.decode().strip()))

	mat = Matrix(GF(p), [line1,line2,line3,line4,line5,line6,line7,line8,line9])
	order = mat.multiplicative_order()

	r.recvuntil(b'matrix M:')

	r.sendline(str(order).encode())
	r.recvuntil(b'wait...\n')
	r.recvline()
def r8():
	l1 = r.recvline().replace(b'[',b'').replace(b']',b'').strip().split()
	l2 = r.recvline().replace(b'[',b'').replace(b']',b'').strip().split()
	l3 = r.recvline().replace(b'[',b'').replace(b']',b'').strip().split()
	l4 = r.recvline().replace(b'[',b'').replace(b']',b'').strip().split()
	l5 = r.recvline().replace(b'[',b'').replace(b']',b'').strip().split()
	l6 = r.recvline().replace(b'[',b'').replace(b']',b'').strip().split()
	l7 = r.recvline().replace(b'[',b'').replace(b']',b'').strip().split()
	l8 = r.recvline().replace(b'[',b'').replace(b']',b'').strip().split()
	l9 = r.recvline().replace(b'[',b'').replace(b']',b'').strip().split()
	l10 = r.recvline().replace(b'[',b'').replace(b']',b'').strip().split()

	line1 = []
	line2 = []
	line3 = []
	line4 = []
	line5 = []
	line6 = []
	line7 = []
	line8 = []
	line9 = []
	line10 = []
	for i in l1:
		line1.append(int(i.decode().strip()))
	for i in l2:
		line2.append(int(i.decode().strip()))
	for i in l3:
		line3.append(int(i.decode().strip()))
	for i in l4:
		line4.append(int(i.decode().strip()))
	for i in l5:
		line5.append(int(i.decode().strip()))
	for i in l6:
		line6.append(int(i.decode().strip()))
	for i in l7:
		line7.append(int(i.decode().strip()))
	for i in l8:
		line8.append(int(i.decode().strip()))
	for i in l9:
		line9.append(int(i.decode().strip()))
	for i in l10:
		line10.append(int(i.decode().strip()))

	mat = Matrix(GF(p), [line1,line2,line3,line4,line5,line6,line7,line8,line9,line10])
	order = mat.multiplicative_order()

	r.recvuntil(b'matrix M:')

	r.sendline(str(order).encode())
	r.recvuntil(b'wait...\n')
	r.recvline()
def r9():
	l1 = r.recvline().replace(b'[',b'').replace(b']',b'').strip().split()
	l2 = r.recvline().replace(b'[',b'').replace(b']',b'').strip().split()
	l3 = r.recvline().replace(b'[',b'').replace(b']',b'').strip().split()
	l4 = r.recvline().replace(b'[',b'').replace(b']',b'').strip().split()
	l5 = r.recvline().replace(b'[',b'').replace(b']',b'').strip().split()
	l6 = r.recvline().replace(b'[',b'').replace(b']',b'').strip().split()
	l7 = r.recvline().replace(b'[',b'').replace(b']',b'').strip().split()
	l8 = r.recvline().replace(b'[',b'').replace(b']',b'').strip().split()
	l9 = r.recvline().replace(b'[',b'').replace(b']',b'').strip().split()
	l10 = r.recvline().replace(b'[',b'').replace(b']',b'').strip().split()
	l11 = r.recvline().replace(b'[',b'').replace(b']',b'').strip().split()

	line1 = []
	line2 = []
	line3 = []
	line4 = []
	line5 = []
	line6 = []
	line7 = []
	line8 = []
	line9 = []
	line10 = []
	line11 = []
	for i in l1:
		line1.append(int(i.decode().strip()))
	for i in l2:
		line2.append(int(i.decode().strip()))
	for i in l3:
		line3.append(int(i.decode().strip()))
	for i in l4:
		line4.append(int(i.decode().strip()))
	for i in l5:
		line5.append(int(i.decode().strip()))
	for i in l6:
		line6.append(int(i.decode().strip()))
	for i in l7:
		line7.append(int(i.decode().strip()))
	for i in l8:
		line8.append(int(i.decode().strip()))
	for i in l9:
		line9.append(int(i.decode().strip()))
	for i in l10:
		line10.append(int(i.decode().strip()))
	for i in l11:
		line11.append(int(i.decode().strip()))

	mat = Matrix(GF(p), [line1,line2,line3,line4,line5,line6,line7,line8,line9,line10,line11])
	order = mat.multiplicative_order()

	r.recvuntil(b'matrix M:')

	r.sendline(str(order).encode())
	r.recvuntil(b'wait...\n')
	r.recvline()
def r10():
	l1 = r.recvline().replace(b'[',b'').replace(b']',b'').strip().split()
	l2 = r.recvline().replace(b'[',b'').replace(b']',b'').strip().split()
	l3 = r.recvline().replace(b'[',b'').replace(b']',b'').strip().split()
	l4 = r.recvline().replace(b'[',b'').replace(b']',b'').strip().split()
	l5 = r.recvline().replace(b'[',b'').replace(b']',b'').strip().split()
	l6 = r.recvline().replace(b'[',b'').replace(b']',b'').strip().split()
	l7 = r.recvline().replace(b'[',b'').replace(b']',b'').strip().split()
	l8 = r.recvline().replace(b'[',b'').replace(b']',b'').strip().split()
	l9 = r.recvline().replace(b'[',b'').replace(b']',b'').strip().split()
	l10 = r.recvline().replace(b'[',b'').replace(b']',b'').strip().split()
	l11 = r.recvline().replace(b'[',b'').replace(b']',b'').strip().split()
	l12 = r.recvline().replace(b'[',b'').replace(b']',b'').strip().split()

	line1 = []
	line2 = []
	line3 = []
	line4 = []
	line5 = []
	line6 = []
	line7 = []
	line8 = []
	line9 = []
	line10 = []
	line11 = []
	line12 = []
	for i in l1:
		line1.append(int(i.decode().strip()))
	for i in l2:
		line2.append(int(i.decode().strip()))
	for i in l3:
		line3.append(int(i.decode().strip()))
	for i in l4:
		line4.append(int(i.decode().strip()))
	for i in l5:
		line5.append(int(i.decode().strip()))
	for i in l6:
		line6.append(int(i.decode().strip()))
	for i in l7:
		line7.append(int(i.decode().strip()))
	for i in l8:
		line8.append(int(i.decode().strip()))
	for i in l9:
		line9.append(int(i.decode().strip()))
	for i in l10:
		line10.append(int(i.decode().strip()))
	for i in l11:
		line11.append(int(i.decode().strip()))
	for i in l12:
		line12.append(int(i.decode().strip()))

	mat = Matrix(GF(p), [line1,line2,line3,line4,line5,line6,line7,line8,line9,line10,line11,line12])
	order = mat.multiplicative_order()

	r.recvuntil(b'matrix M:')

	r.sendline(str(order).encode())
	r.recvuntil(b'wait...\n')
	r.recvline()
def r11():
	l1 = r.recvline().replace(b'[',b'').replace(b']',b'').strip().split()
	l2 = r.recvline().replace(b'[',b'').replace(b']',b'').strip().split()
	l3 = r.recvline().replace(b'[',b'').replace(b']',b'').strip().split()
	l4 = r.recvline().replace(b'[',b'').replace(b']',b'').strip().split()
	l5 = r.recvline().replace(b'[',b'').replace(b']',b'').strip().split()
	l6 = r.recvline().replace(b'[',b'').replace(b']',b'').strip().split()
	l7 = r.recvline().replace(b'[',b'').replace(b']',b'').strip().split()
	l8 = r.recvline().replace(b'[',b'').replace(b']',b'').strip().split()
	l9 = r.recvline().replace(b'[',b'').replace(b']',b'').strip().split()
	l10 = r.recvline().replace(b'[',b'').replace(b']',b'').strip().split()
	l11 = r.recvline().replace(b'[',b'').replace(b']',b'').strip().split()
	l12 = r.recvline().replace(b'[',b'').replace(b']',b'').strip().split()
	l13 = r.recvline().replace(b'[',b'').replace(b']',b'').strip().split()

	line1 = []
	line2 = []
	line3 = []
	line4 = []
	line5 = []
	line6 = []
	line7 = []
	line8 = []
	line9 = []
	line10 = []
	line11 = []
	line12 = []
	line13 = []
	for i in l1:
		line1.append(int(i.decode().strip()))
	for i in l2:
		line2.append(int(i.decode().strip()))
	for i in l3:
		line3.append(int(i.decode().strip()))
	for i in l4:
		line4.append(int(i.decode().strip()))
	for i in l5:
		line5.append(int(i.decode().strip()))
	for i in l6:
		line6.append(int(i.decode().strip()))
	for i in l7:
		line7.append(int(i.decode().strip()))
	for i in l8:
		line8.append(int(i.decode().strip()))
	for i in l9:
		line9.append(int(i.decode().strip()))
	for i in l10:
		line10.append(int(i.decode().strip()))
	for i in l11:
		line11.append(int(i.decode().strip()))
	for i in l12:
		line12.append(int(i.decode().strip()))
	for i in l13:
		line13.append(int(i.decode().strip()))

	mat = Matrix(GF(p), [line1,line2,line3,line4,line5,line6,line7,line8,line9,line10,line11,line12,line13])
	order = mat.multiplicative_order()

	r.recvuntil(b'matrix M:')

	r.sendline(str(order).encode())
	r.recvuntil(b'wait...\n')
	r.recvline()
def r12():
	l1 = r.recvline().replace(b'[',b'').replace(b']',b'').strip().split()
	l2 = r.recvline().replace(b'[',b'').replace(b']',b'').strip().split()
	l3 = r.recvline().replace(b'[',b'').replace(b']',b'').strip().split()
	l4 = r.recvline().replace(b'[',b'').replace(b']',b'').strip().split()
	l5 = r.recvline().replace(b'[',b'').replace(b']',b'').strip().split()
	l6 = r.recvline().replace(b'[',b'').replace(b']',b'').strip().split()
	l7 = r.recvline().replace(b'[',b'').replace(b']',b'').strip().split()
	l8 = r.recvline().replace(b'[',b'').replace(b']',b'').strip().split()
	l9 = r.recvline().replace(b'[',b'').replace(b']',b'').strip().split()
	l10 = r.recvline().replace(b'[',b'').replace(b']',b'').strip().split()
	l11 = r.recvline().replace(b'[',b'').replace(b']',b'').strip().split()
	l12 = r.recvline().replace(b'[',b'').replace(b']',b'').strip().split()
	l13 = r.recvline().replace(b'[',b'').replace(b']',b'').strip().split()
	l14 = r.recvline().replace(b'[',b'').replace(b']',b'').strip().split()

	line1 = []
	line2 = []
	line3 = []
	line4 = []
	line5 = []
	line6 = []
	line7 = []
	line8 = []
	line9 = []
	line10 = []
	line11 = []
	line12 = []
	line13 = []
	line14 = []
	for i in l1:
		line1.append(int(i.decode().strip()))
	for i in l2:
		line2.append(int(i.decode().strip()))
	for i in l3:
		line3.append(int(i.decode().strip()))
	for i in l4:
		line4.append(int(i.decode().strip()))
	for i in l5:
		line5.append(int(i.decode().strip()))
	for i in l6:
		line6.append(int(i.decode().strip()))
	for i in l7:
		line7.append(int(i.decode().strip()))
	for i in l8:
		line8.append(int(i.decode().strip()))
	for i in l9:
		line9.append(int(i.decode().strip()))
	for i in l10:
		line10.append(int(i.decode().strip()))
	for i in l11:
		line11.append(int(i.decode().strip()))
	for i in l12:
		line12.append(int(i.decode().strip()))
	for i in l13:
		line13.append(int(i.decode().strip()))
	for i in l14:
		line14.append(int(i.decode().strip()))

	mat = Matrix(GF(p), [line1,line2,line3,line4,line5,line6,line7,line8,line9,line10,line11,line12,line13,line14])
	order = mat.multiplicative_order()

	r.recvuntil(b'matrix M:')

	r.sendline(str(order).encode())

r1()
r2()
r3()
r4()
r5()
r6()
r7()
r8()
r9()
r10()
r11()
r12()

r.interactive()

#CCTF{ma7RicES_4R3_u5EfuL_1n_PUbl!c-k3y_CrYpt0gr4Phy!}
