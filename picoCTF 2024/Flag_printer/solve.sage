from Crypto.Util.number import *
from tqdm import tqdm
from multiprocessing import Pool
import time

MOD = 7514777789

def get_points_mult():
    points = []

    for line in open('encoded.txt', 'r').read().strip().split('\n'):
        x, y = line.split(' ')
        points.append([int(x), int(y)])
    n = len(points)
    F = GF(MOD)

    factorials = [1]
    for i in tqdm(range(n-1)):
        factorials.append(F(factorials[i] * (i+1)))

    denoms = []
    for i in tqdm(range(len(points))):
        total = (-1)^((n-(i+1)) % 2)
        total *= factorials[n-(i+1)]
        total *= factorials[(i+1)-1]
        denoms.append(F(total)^-1)

    fs = []
    for i in points:
        fs.append(i[1])

    mults = []
    for a,b in zip(fs, denoms):
        mults.append(F(a*b))

    return points, mults

points, mults = get_points_mult()

P.<x> = PolynomialRing(GF(MOD))
f = product([x-i for i in range(len(points))])

def para(indexes):

    final_poly = 0
    for i in range(indexes[0], indexes[1]):
        frac = f / (x-i)
        frac *= mults[i]
        final_poly += frac
    return final_poly

if __name__ == "__main__":
    cores = 112

    start = time.time()
    pool = Pool(cores)
    indexes = []
    x = len(points)//cores
    for i in range(cores - 1):
        indexes.append([x*i, x*(i+1)])
    indexes.append([indexes[-1][1], len(points)])

    polys = 0
    with pool:
        for i in pool.imap_unordered(para, indexes):
            polys += i

    monomials = str(polys.numerator().list())
    open("polytext.txt", "w").write(monomials)