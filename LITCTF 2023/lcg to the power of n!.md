# LCG to the power of n!

By: SuperBeetleGamer

1 lcg isnt enough..... 2 lcgs isnt enough...? Well I will never use one of those inferior prngs, but idk how to make this secure. Oh wait I know, I should add even more lcgs!

## Solve

The most important part of the source is as follows:
```py
from Crypto.Util.number import getPrime
from random import SystemRandom
random = SystemRandom()
n = 64
d = 16
P = getPrime(n)

A = random.getrandbits(n)
B = random.getrandbits(n)
xs = []
class lcg:
    def __init__(self):
        self.a = A
        self.b = B
        self.x = random.getrandbits(n)
        xs.append(self.x)
        self.m = P
    def next(self):
        self.x = (self.a * self.x + self.b) % self.m
        return self.x + random.randint(-P//(2**9) + 1, P//(2**9)) # whats life without a lil error!

lcgs = []
for x in range(d):
    lcgs.append(lcg())

print(f"{P = }\n{xs = }\nout = {[x.next() for x in lcgs]}") # smh ig you can have these
```

We get 16 iterations of an lcg except for the fact that its got errors applied to it. Had they been exact, we could just set up a system of equations and solve it via Gaussian Reduction. But wait... can we still do something similar to that?

Enter CVP! CVP or the Closest Vector Problem takes a Lattice L and target point V. It outputs a point on the lattice that is closest to the target point. To get around the modulus we can change each equation from:

$ax_0 + b \equiv x_1 (mod p)$

to 

$ax_0 + b - kp = x_1$ for some k.

Thus, we can set up the lattice as follows. We put P's on the diagonals and augment the matrix down 2 rows with the second to last row as 1's and the last row as the xs values.

The target vector are the other out values that each equation is equal to. Then, just perform LLL and chuck Baibai's closest vector algorithm at it and we get a vector that most accurately represents the true x values.

All we have to do after that is to solve the system of equations via Guassian Reduction with our new closest vector to find the values of A and B. Iterate through the LCG again and we get our key and flag!

Full solve code below:
```py
from sage.modules.free_module_integer import IntegerLattice

def Babai_closest_vector(M, G, target):
    small = target
    for _ in range(1):
        for i in reversed(range(M.nrows())):
            c = ((small * G[i]) / (G[i] * G[i])).round()
            small -= M[i] * c
    return target - small

P = 13131324022074804079
xs = [818660445928296216, 4304663454498751845, 8078700408623796749, 1778475378977596779, 12824664706131170268, 10420761949177186522, 6845546710088149747, 14110579524723166104, 14897039251261399439, 3774734634946337646, 15279708159821145288, 8906678690214943251, 11119738051050899844, 1841284253154569101, 2783084396686288544, 11854686581894585340]
out = [12991798441769803093, 7498783580600923236, 9188781492566527528, 12845033212340891357, 5565380757767757248, 11625073182050856072, 12465139570398461776, 1031252012263875382, 12115687014180020079, 116379706792989403, 9685641342885785654, 9806645816574735805, 9466308272233367959, 12187856198301834495, 12544820285589854231, 6524905402046307976]

M = Matrix(ZZ, len(xs)+2, len(xs))
for i in range(len(xs)):
    M[i,i] = P
for i in range(len(xs)):
    M[len(xs), i] = 1
    M[len(xs)+1, i] = xs[i]
    
target = vector(ZZ, out)
lattice = IntegerLattice(M, lll_reduce=True)
gram = lattice.reduced_basis.gram_schmidt()[0]
res = Babai_closest_vector(lattice.reduced_basis, gram, target)

print(res)

p = 13131324022074804079
A = Matrix(GF(p), len(xs), 2)
for i in range(len(xs)):
    A[i,0] = xs[i]
    A[i,1] = 1
ans = A.solve_right(res)
print(ans)
```

## Flag

`LITCTF{Its_all_HNP?_Always_has_been}`

