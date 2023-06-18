# Secure PrimeGenerator
By: SuperBeetleGamer (SBG)

## Description

Do you miss prime generator from last year? We would like to introduce brand new one. This is more secure because p, q are not revealed.

`nc 13.125.181.74 9001`

## Solve

Okay, let's analyze `prod.py`. I didn't like `client_exmaple.py` at all so I basically scrapped it and wrote my own thing (although the POW() was useful). Anyways, `prod.py` time. We are going to skip the POW() function because `client_example.py` has a good solver for that.

```py
def generate_server_key():
    while True:
        p = getPrime(1024)
        q = getPrime(1024)
        e = 0x10001
        if (p-1) % e == 0 or (q-1) % e == 0:
            continue
        d = pow(e, -1, (p-1)*(q-1))
        n = p*q
        return e, d, n
```

This is pretty standard. It generates two 1024 bit primes, a pub and priv key, and the modulus. Standard stuff. Nothing much to see here.

```py
def generate_shared_modulus():
    SMALL_PRIMES = [2, 3, 5, 7, 11, 13]
    print(f"{SERVER_N = }")
    print(f"{SERVER_E = }")

    p1_remainder_candidates = {}
    q1_remainder_candidates = {}    
    # We prevent p1+p2 is divided by small primes
    # by asking the client for a possible remainders of p1
    for prime in SMALL_PRIMES:
        remainder_candidates = set(map(int, input(f"Candidates of p1 % {prime} > ").split()))
        assert len(remainder_candidates) == (prime+1) // 2, f"[-] wrong candidates for {prime}"
        p1_remainder_candidates[prime] = remainder_candidates
    
    while True:
        p1 = bytes_to_long(os.urandom(BITS // 8))        
        for prime in SMALL_PRIMES:
            if p1 % prime not in p1_remainder_candidates[prime]:
                break
        else:
            break
    
    # and same goes for q1
    for prime in SMALL_PRIMES:
        remainder_candidates = set(map(int, input(f"Candidates of q1 % {prime} > ").split()))
        assert len(remainder_candidates) == (prime+1) // 2, f"[-] wrong candidates for {prime}"
        q1_remainder_candidates[prime] = remainder_candidates
    
    while True:
        q1 = bytes_to_long(os.urandom(BITS // 8))
        
        for prime in SMALL_PRIMES:
            if q1 % prime not in q1_remainder_candidates[prime]:
                break
        else:
            break

    p1_enc = pow(p1, SERVER_E, SERVER_N)
    q1_enc = pow(q1, SERVER_E, SERVER_N)    

    print(f"{p1_enc = }")
    print(f"{q1_enc = }")
    X = list(map(int, input("X > ").split()))
    assert len(X) == 12
    
    N = (p1*q1 + sum(pow(x, SERVER_D, SERVER_N) for x in X)) % SERVER_N
    #assert N.bit_length() >= 1024, f"[-] too short.., {N.bit_length()}"

    print(f"{N = }")
    
    return p1, q1, N
```

I'm not going to lie. I didn't really understand a lot of what was going on here. Especially the small prime checking part. It didn't make sense to me. Sorry if this butchers my writuep but I didn't get it at all. However, beside that point, the interesting part that caught my eye was:

```py
p1_enc = pow(p1, SERVER_E, SERVER_N)
q1_enc = pow(q1, SERVER_E, SERVER_N)    

print(f"{p1_enc = }")
print(f"{q1_enc = }")
X = list(map(int, input("X > ").split()))
assert len(X) == 12

N = (p1*q1 + sum(pow(x, SERVER_D, SERVER_N) for x in X)) % SERVER_N
```

We are given:

$p_1^e, q_1^e$

And we are allowed to submit 12 X's such that they will be decrypted and added to p1\*q1. Thus, we get:

$p_1\*q_1 + X_1^d + X_2^d + X_3^d + ... + X_{12}^d$

Well. Now what?
Observe that we are given the encrypted versions of $p_1$ and $q_1$. We are also given `n` and `e` allowing us to encrypt anything we want. Since the server decrypts all of our inputs, we have total control over what we want N to be. Sweet!

Let's put that aside for now and analyze the last validity check.

```py
def N_validity_check(p1, q1, N):
    for _ in range(20):
        b = bytes_to_long(os.urandom(2 * BITS // 8))
        print(f"{b = }")
        client_digest = input("Client digest > ")
        server_digest = sha256(long_to_bytes(pow(b, N+1-p1-q1, N))).hexdigest()
        if server_digest != client_digest:
            print("N is not a product of two primes I guess..")
            return False
        else:
            print("good!")
     
    return True
```

Hmmmmm. So the server will give us a random value `b` and perform $b^{N+1-p_1-q_1}$ and then hash it. It asks us for our hash first as we have to figure out the hash of this value before they calculate it. Well... how do we do this? Remember earlier when I mentioned that you can control N to anything you want? Well, let's do it!

For my solution, I submitted $-(p_1\*q_1)^{e}$, $p_1^e$, $q_1^e$, and $(2^{1024})^e$. Why? Well, lets expand it out:

Everything get's decrypted so I'll just get rid of the e's. We get:

$N = p_1\*q_1 - p_1\*q_1 + p_1 + q_1 + 2^{1024} = p_1 + q_1 + 2^{1024}$

This means that $b^{N+1-p_1-q_1}$ is really just $b^{2^{1024} + 1}$. Nice, we pass the validity check.

Now, the server spits back the encrypted flag and the modulus and its standard RSA decryption from there. Now you may be thinking, SBG isn't a 1024 bit RSA modulus really hard to factor. Yes. It is. But at 3am, SBG gets lucky. In fact, he got so lucky, that he chucked his modulus into alpetron to factor it. What did it come out as?

```
2 × 79 × 197 × 331 × 1951 × 242284776447128900047 × 453016665277106025673 × 81482937651594313583829527111273223306556576964154040387016862837396935685927023114936269140818613754629499849649607817661052202571281081174195033576801632940199296809894893973770596417596050208557498070458753960687937906773171178824916346162886182342410389
```

Yeah. SBG whipped out a 257 digit prime. Fully factored a 1024 bit RSA. After that, it's just standard RSA decryption so I won't be going over that.

## Flag

```
codegate2023{40c0e0c0f5049b35fe0c86fbdb324f198e416007a83f07a85add5390c7a75716f3c29144a4498c26ec17f9dbff1419}
```

## Full solve script
```py
from Crypto.Util.number import *
from hashlib import sha256
from pwn import *
from itertools import product
import random

def POW():
    print("[DEBUG] POW...")
    b_postfix = r.recvline().decode().split(' = ')[1][6:].strip()
    h = r.recvline().decode().split(' = ')[1].strip()
    for brute in product('0123456789abcdef', repeat=6):
        b_prefix = ''.join(brute)
        b_ = b_prefix + b_postfix
        if sha256(bytes.fromhex(b_)).hexdigest() == h:
            r.sendlineafter(b' > ', b_prefix.encode())
            return True

    assert 0, "Something went wrong.."

r = remote("13.125.181.74", 9001)
POW()
SERVER_N = int(r.recvline().decode().split(' = ')[1])
SERVER_E = int(r.recvline().decode().split(' = ')[1])

t = ["1", "1 2", "2 3 4", "6 5 4 3", "10 9 8 7 6 5", "13 12 10 9 8 7 6"]

for i in t:
    r.sendlineafter(b' > ', i.encode())

for i in t:
    r.sendlineafter(b' > ', i.encode())

p1_enc = int(r.recvline().decode().split(' = ')[1])
q1_enc = int(r.recvline().decode().split(' = ')[1])

neg = -((p1_enc*q1_enc) % SERVER_N)
power_2 = pow(2**1024, SERVER_E, SERVER_N)

X = [neg, power_2, p1_enc, q1_enc] + [0]*8

r.sendlineafter(b' > ', ' '.join(str(x) for x in X).encode())

N = int(r.recvline().decode().split(' = ')[1])
for _ in range(20):
    b = int(r.recvline().decode().split(' = ')[1])
    client_digest = sha256(long_to_bytes(pow(b, 2**1024+1, N))).hexdigest()
    r.sendlineafter(b' > ', client_digest.encode())
    msg = r.recvline().decode()
    if msg != "good!\n":
        print(msg)

print("N: " + str(N))
print("enc_flag: " + r.recvline().decode().split(' = ')[1])

# SUPERBEETLEGAMER's 3AM LUCK LESGOOOOOOOOO
#N: 179769313486231590772930519078902473361797697894230657273430081157732675805500963132708477322407536021120113879871393357658789768814416622492847430639474135679749626505809262740406778629186965110961120022182960325657226722014064214956640521017152701374779671181500923261888466344423848038026722368987680881354
#enc_flag: 112599011853065082905314541981511562111071921747402372963232235336460886142329072768516769431462456175691553296574776538150363614178816536535754770661247557333653420201144789153833898958033091160200064597635337701732781342547476009496020257951375941147793508759562785166624775095907937666550072869775511269254
```



