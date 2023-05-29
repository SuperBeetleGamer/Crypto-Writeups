# Tau as a Service

I played for .;,;. for angstromCTF and for verification, here is the writeup for Tau as a Service

## Challenge Description ##

Who needs powers-of-tau ceremonies when you have τaas?

`nc challs.actf.co 32500`

## Solve ##

Tl;Dr: Use Cheon's algorithm to find tau

We are given a relatively simply source:
```py
#!/usr/local/bin/python

from blspy import PrivateKey as Scalar

# order of curve
n = 0x73EDA753299D7D483339D80809A1D80553BDA402FFFE5BFEFFFFFFFF00000001

with open('flag.txt', 'rb') as f:
	tau = int.from_bytes(f.read().strip(), 'big')
	assert tau < n

while True:
	d = int(input('gimme the power: '))
	assert 0 < d < n
	B = Scalar.from_bytes(pow(tau, d, n).to_bytes(32, 'big')).get_g1()
	print(B)
```
Well, time to desect this a little bit. 

Firstly, it uses a flag value `tau` and gives us the option to enter an exponent `d` which it then multiplies with a generator point called by `.get_g1()`.
So generally, we get values in the form of:

```math
\tau^{d} \cdot G
```

After a bit of researching on ecc multiplication, I came across something called Cheon's algorithm that was designed to solve this exact problem. Unfortunately, the complexitiy for the base algorithm would take way to long. Luckily, in the [original paper](https://link.springer.com/article/10.1007/s00145-009-9047-0), Cheon had another algorithm that runs much faster with more inputs.

This new algorithm assumes we know the factors of p-1 and are able to request multiple points. If this was confusing it's shown below:

```math
p-1 = d_1 \cdot d_2 \cdot d_3 \cdot ... \cdot d_k
```
```math
\tau^{\frac{p-1}{d_1}} \cdot G, ... ,  \tau^{\frac{p-1}{d_k}} \cdot G
```
Luckily, the order of point `G` is very smooth:
```
[2^32, 3, 11, 19, 10177, 125527, 859267, 906349^2, 2508409, 2529403, 52437899, 254760293^2]
```
Thus, we can directly find all the values of 
```math
\frac{p-1}{d_k}
```
for every k.

Then, it is just a matter of requesting the server for these expoenents and converting the bytes to point. (This can be found [here from the blspy library](https://github.com/Achi-Coin/blspy/blob/master/python-impl/ec.py#L262))

After that, we directly implement Cheon's algorithm and find the values of k.

```py
from Crypto.Util.number import *
from sage.groups.generic import bsgs
import random
from tqdm import tqdm


q = 0x1A0111EA397FE69A4B1BA7B6434BACD764774B84F38512BF6730D2A0F6B0F6241EABFFFEB153FFFFB9FEFFFFFFFFAAAB
E = EllipticCurve(GF(q), [0,4])
G = E(0x17F1D3A73197D7942695638C4FA9AC0FC3688C4F9774B905A14E3A3F171BAC586C55E83FF97A1AEFFB3AF00ADB22C6BB, 0x08B3F481E3AAA0F1A09E30ED741D8AE4FCF5E095D5D00AF600DB18CB2C04B3EDD03CC744A2888AE40CAA232946C5E7E1)

p = 0x73EDA753299D7D483339D80809A1D80553BDA402FFFE5BFEFFFFFFFF00000001
order = p-1
facs = [2^32,3,11,19,10177,125527,859267,906349^2,2508409,2529403,52437899,254760293^2]

vals = [E(0x16ae116920f158e25d9e18c54370afe1d215d26df7d17d13fb2957ba3563d88b35573cd41f4a0b7e9795246a3490cf57, 0x24bd8e65509d11e17a31f171432ef3fab0982170ad858065f89401ddf3e9d18055960971be09f28b1bae19571d8f372), 
        E(0x1333c91030ee7a4649e404c01b2e0d26a8728dd7cb4edb636ed984de104bb92674f1161d8c99bcf024e473fe0a1d7620, 0x8b3f481e3aaa0f1a09e30ed741d8ae4fcf5e095d5d00af600db18cb2c04b3edd03cc744a2888ae40caa232946c5e7e1), 
        E(0x18d830decdac7cbc4ed79d4ea6d5323f936de5db8f0065f1b87a499076ec83ecc656b131c2b6331fae0d6b052398975c, 0x46afd9bd7fecc2c4e4c9a73fea961cf6638522df0dd32dd385c0276df13480debb4c95053fe26bce3d4980b32443643), 
        E(0x19252a4d28fed664a14c43b83bab4edba7e5c0434572f056b3774d147c3dfb02f974e28c6e2a563a76c295c95389c5e7, 0x5ae7bc03fa23ebe5a627f24470b871e35f26e81bc41f1497011237002fb11816ba133060258a6c88d39b15ac589db5d), 
        E(0x22f21ee2bc1f2943d5f15630037494ae9efc20b8fdb1d8ff60d8ad7bba074ecfd3109210e10f8fdbda983f3646c3102, 0x72059499e0d362621402f50f5af3ee588dee5dd51c616f027de38381773df0897cf91460bd63c9b655b6b69a15d8df7), 
        E(0x3349a4ac5a912b57997d8f23b180a333d52cc25d50b4450e5f7507b7d74a8cf54bbd3ce2452520711d941880322dc0e, 0x8e82d8cc7804b04f336942bcc583f02f6ffc62523c603957c3e453675ee723e0fbb913d7302df9cacaeffdf58593fd9), 
        E(0x189586f81b03a5ddbc8bd46b280244fa4333038d50426ee540400999292f006102958b7640f9f2501d5d1a0fc061f4c5, 0x5ff6a0f94b8759414cb78d8963e1aed90a3a17e5c6c909a19f42c1a9ec206f12cbd8e39894df02c9fb86ac84086a484), 
        E(0x118b7859120a732922aa323be1ee2b9816a7196c0e6ae142337f8368ec71291967b717a8e4f4bb084cc642501a067d24, 0x46c3ebb4404fe64b90d77108043bdec27d3a61f4416794297ccf7747de71affafd55349868dbf021d7e98877731ebe), 
        E(0x13e07427cfde4fd4c77fbe7c33b32ce816498365b9db110e59bd2126d7e4a6f1a8394d8e7458afebc15f4690c35d425d, 0x4f441e21f8c0a40dfb89ac369b592ec0214669bafe2d219e9f0b67338965261dd2fc2946412f10ee9405bf5c030a943), 
        E(0x149f44c3648486c6ef123a3808089f07da2a04a9de9caa79b423d41b94c015fa5e8186218a850077845c0166f7ddc56d, 0xcc94ea382337a8fa0b1d556fff025c0462163f2d2c3b33a8e9c9fb5a7f93d156087bdc53f140280f48863ef7df719b1), 
        E(0xa05ae50c421c40654689cd9e386558fff84aad52ec77f4f4077a9ee93f0c429b69372df16d45a17aa30063d3063930, 0x3f66235adcc78708a7660565f1ec6ff6e93ceeced78f89a745d844222c4aedf5c2e119a9bef63a0961dbc8fb8c5e79c), 
        E(0x13d014b94eb0af5272abe97342bc46f847823114820b07b0cbc9b7d740b39debd61292b4b824f3aaad91fd4b66bfbe92, 0x904a8e8987a086e68b581d3521b5676a62fc67a864f5b083275877d6e120ecf92ae8e84070cf995cd7bc6fcf848ecf2)]

facs = facs[:-1]
vals = vals[:-1]

gen_p = random.randint(1,order)
#Found = False
#while not Found:
    #gen_p = random.randint(1,order)
    #if all([pow(gen_p,(order//i),p) != 1 for i in facs]):
        #Found = True

#This was found from the process above but we kept it the same for testing purposes
gen_p = 2656104828869835352448344720817663641345232991538644107036479384834072681653

omegas = []
for i in facs:
    omegas.append(pow(gen_p,order//i,p))

us = []
vs = []
for fac in range(len(facs)):
    table = {}
    if facs[fac] == 3:
        d = ceil(isqrt(facs[fac]))
        for i in tqdm(range(3)):
            left = pow(omegas[fac],(-i)%order,p)*vals[fac]
            table[int(left[0])] = i
        for i in tqdm(range(3)):
            right = pow(omegas[fac],(d*i),p)*G
            try:
                val = table[int(right[0])]
                us.append(val)
                vs.append(i)
                break
            except:
                continue

    elif facs[fac] == 19:
        d = ceil(isqrt(facs[fac]))
        for i in tqdm(range(19)):
            left = pow(omegas[fac],(-i)%order,p)*vals[fac]
            table[int(left[0])] = i
        for i in tqdm(range(19)):
            right = pow(omegas[fac],(d*i),p)*G
            try:
                val = table[int(right[0])]
                us.append(val)
                vs.append(i)
                break
            except:
                continue

    else:
        d = ceil(isqrt(facs[fac]))
        for i in tqdm(range(d)):
            left = pow(omegas[fac],(-i)%order,p)*vals[fac]
            table[int(left[0])] = i
        for i in tqdm(range(d)):
            right = pow(omegas[fac],(d*i),p)*G
            try:
                val = table[int(right[0])]
                us.append(val)
                vs.append(i)
            except:
                continue

ks = []
for u,v,d in zip(us,vs,facs):
    k = int(ceil(isqrt(d)))*v + u
    ks.append(k)

print(ks, facs)
print(gen_p)
```

However, the last factor was giving a bit of an issue. It was too large to do BSGS straight up as it would have had a complexitiy of ~2^27. 


~~Luckily, we had a huge powerful computer and ran a multiprocessing script on 15 cores and about 50gb of memory (linked in the Appendix)~~

Just kidding, turns out, if you can use the pohlig hellman implementation on prime powers to solve for the last factor which will take about ~2^13, much more feasible. The wiki shows how to implement the algorithm pretty well, so I won't go over it in this writeup. Basically, you reduce the discrete log over to the integers and multiply it by G only on the BSGS part. This was done a seperate script below.

```py
from tqdm import tqdm

zeta = 2656104828869835352448344720817663641345232991538644107036479384834072681653
fac = 254760293^2
p = 0x73EDA753299D7D483339D80809A1D80553BDA402FFFE5BFEFFFFFFFF00000001

q = 0x1A0111EA397FE69A4B1BA7B6434BACD764774B84F38512BF6730D2A0F6B0F6241EABFFFEB153FFFFB9FEFFFFFFFFAAAB
E = EllipticCurve(GF(q), [0,4])
G = E(0x17F1D3A73197D7942695638C4FA9AC0FC3688C4F9774B905A14E3A3F171BAC586C55E83FF97A1AEFFB3AF00ADB22C6BB, 0x08B3F481E3AAA0F1A09E30ED741D8AE4FCF5E095D5D00AF600DB18CB2C04B3EDD03CC744A2888AE40CAA232946C5E7E1)

vals = [E(0xb5c0fc0a95cae99b3db183d04c10134559e98ccbc657783ba6d8ec9f3c363409290ad88ff892769c7c0cfb59b519dc8, 0xf537982de512ab9dfc2807d1c82c4e607bc5cf5a2d49f9ea85e96ca4d369d1a31292ebb4be714556333ffe35849e), E(0x13d014b94eb0af5272abe97342bc46f847823114820b07b0cbc9b7d740b39debd61292b4b824f3aaad91fd4b66bfbe92, 0x904a8e8987a086e68b581d3521b5676a62fc67a864f5b083275877d6e120ecf92ae8e84070cf995cd7bc6fcf848ecf2)]

#vals[0] was the point with exponent (p-1)/254760293
#vals[1] was the point with exponent (p-1)/254760293^2

order = p-1

total = ceil(isqrt(fac))
zeta2 = pow(zeta, order//(fac), p)
us = 0
vs = 0

gamma = pow(zeta2,254760293,p)
xk = 0

# tau^(p-1/d) = zeta^(p-1/d)k
hk = vals[0]

us = 0
vs = 0
table = {}
for i in tqdm(range(int(ceil(isqrt(total))))):
	left = pow(gamma,(-i)%order,p)*hk
	table[int(left[0])] = i
for i in tqdm(range(int(ceil(isqrt(total))))):
	right = pow(gamma,ceil(isqrt(total))*i,p)*G
	try:
		val = table[int(right[0])]
		us += val
		vs += i
		break
	except:
		continue

dk = int(ceil(isqrt(total)))*vs + us
xk = dk

hk = pow(zeta2,(-xk%order),p)*vals[1]

us = 0
vs = 0
table = {}
for i in tqdm(range(int(ceil(isqrt(total))))):
	left = pow(gamma,(-i)%order,p)*hk
	table[int(left[0])] = i
for i in tqdm(range(int(ceil(isqrt(total))))):
	right = pow(gamma,ceil(isqrt(total))*i,p)*G
	try:
		val = table[int(right[0])]
		us += val
		vs += i
		break
	except:
		continue

dk = int(ceil(isqrt(total)))*vs + us
xk = xk + dk*254760293


print(xk)
``` 

After finding all the values of k and knowing all the factors of the order of G, we just use crt to piece it back together and recover the dlog.
```py
p = 0x73EDA753299D7D483339D80809A1D80553BDA402FFFE5BFEFFFFFFFF00000001

ks = [418673994, 2, 4, 7, 6152, 54176, 712534, 716097939510, 612809, 172263, 49940923, 22169061305145099]
facs = [2^32, 3, 11, 19, 10177, 125527, 859267, 906349^2, 2508409, 2529403, 52437899, 254760293^2]
gen_p = 2656104828869835352448344720817663641345232991538644107036479384834072681653

k = crt(ks, facs)
print(pow(gen_p,k,p))
```
Convert to bytes and flag!

## Flag

`actf{w3_g0t_the_p0wer_tod0_th4t}`

## Apendix

For those of you who made it this far into the writeup, thank you. This was the script that would have gotten us the flag had we had a stronger computer. Unfortuantely, my computer ran out of memory right after the baby steps and could not compute the giant steps. Anyway here it is:

```py
from Crypto.Util.number import *
import random
from multiprocessing import Pool
from tqdm import tqdm

gen_p = 2656104828869835352448344720817663641345232991538644107036479384834072681653
fac = 254760293^2
p = 0x73EDA753299D7D483339D80809A1D80553BDA402FFFE5BFEFFFFFFFF00000001

def main(idx):
	q = 0x1A0111EA397FE69A4B1BA7B6434BACD764774B84F38512BF6730D2A0F6B0F6241EABFFFEB153FFFFB9FEFFFFFFFFAAAB
	E = EllipticCurve(GF(q), [0,4])
	G = E(0x17F1D3A73197D7942695638C4FA9AC0FC3688C4F9774B905A14E3A3F171BAC586C55E83FF97A1AEFFB3AF00ADB22C6BB, 0x08B3F481E3AAA0F1A09E30ED741D8AE4FCF5E095D5D00AF600DB18CB2C04B3EDD03CC744A2888AE40CAA232946C5E7E1)

	vals = E(0x13d014b94eb0af5272abe97342bc46f847823114820b07b0cbc9b7d740b39debd61292b4b824f3aaad91fd4b66bfbe92, 0x904a8e8987a086e68b581d3521b5676a62fc67a864f5b083275877d6e120ecf92ae8e84070cf995cd7bc6fcf848ecf2)

	order = p-1

	zeta = pow(gen_p, order//fac, p)

	table = {}
	d = ceil(isqrt(fac))
	for i in tqdm(range(idx, idx+d//15)):
		left = pow(zeta,(-i)%order,p)*vals
		table[int(left[0])] = i

	return table

def giant(args):
	idx, dictionary = args
	q = 0x1A0111EA397FE69A4B1BA7B6434BACD764774B84F38512BF6730D2A0F6B0F6241EABFFFEB153FFFFB9FEFFFFFFFFAAAB
	E = EllipticCurve(GF(q), [0,4])
	G = E(0x17F1D3A73197D7942695638C4FA9AC0FC3688C4F9774B905A14E3A3F171BAC586C55E83FF97A1AEFFB3AF00ADB22C6BB, 0x08B3F481E3AAA0F1A09E30ED741D8AE4FCF5E095D5D00AF600DB18CB2C04B3EDD03CC744A2888AE40CAA232946C5E7E1)

	order = p-1

	total = ceil(isqrt(fac))

	zeta = pow(gen_p, order//(fac), p)
	us = 0
	vs = 0
	for i in tqdm(range(idx, idx+total//15)):
		right = pow(zeta,(total*i),p)*G
		try:
			val = dictionary[int(right[0])]
			us += val
			vs += i
			print(us,vs)
		except:
			continue

if __name__ == '__main__':
	pool = Pool(15)
	total = ceil(isqrt(fac))
	args = [0, total//15, total//15*2, total//15*3, total//15*4, total//15*5, total//15*6, total//15*7, total//15*8, total//15*9, total//15*10, total//15*11, total//15*12, total//15*13, total//15*14]
	
	dictionary = {}
	with pool:
		for i in pool.imap_unordered(main, args):
			dictionary.update(i)
		new = [dictionary]*15
		for i in pool.imap_unordered(giant, zip(args, new)):
			print(i)

	k = int(ceil(isqrt(fac)))*vs + us
	print(k)
```








