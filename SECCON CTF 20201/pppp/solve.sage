from math import gcd
from Crypto.Util.number import long_to_bytes

f = open('output.txt', 'r').read()

vals = f.split('\n')

n = int(vals[0][4:])
f = Zmod(n)
e = 65537
c = eval(vals[2][4:])

p = gcd(c[0][0], n)
q = n//p

d = int(pow(e,-1,(p-1)*(q-1)))

c = Matrix(Zmod(n), c)

sol = c^d

m1 = long_to_bytes(gcd(sol[1][1], sol[1][2]))
m2 = long_to_bytes(gcd(sol[2][2], sol[2][3]))
flag = m1 + m2
print(flag.decode())