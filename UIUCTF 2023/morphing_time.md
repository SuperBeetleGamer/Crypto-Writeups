# Morphing Time

By: SuperBeetleGamer

I played with ARESx for UIUCTF 2023

## Description

The all revealing Oracle may be revealing a little too much...

`nc morphing.chal.uiuc.tf 1337`

## Solve

Let's analyze the source. At first, it seems like a normal discrete log problem. Keys are created with a generator `g=2` and a 512 bit prime `p`.

The private key `a` is a random number from 2 - (p-1) and the public key `A` is calculated normally as $A = g^a \text{ (mod p)}$.

After connecting to the server, we are given values `g`,`p`,`A` and 2 ciphertexts that contain the flag. Let's analyze the encryption function:

```py
def encrypt_setup(p, g, A):
    def encrypt(m):
        k = randint(2, p - 1)
        c1 = pow(g, k, p)
        c2 = pow(A, k, p)
        c2 = (m * c2) % p

        return c1, c2

    return encrypt

encrypt = encrypt_setup(p, g, A)
c1, c2 = encrypt(flag)
```

Okay let's break it down. Inputs for the encryption are the public values given to us by the server and the plaintext, which is flag in this case.

Mathematically, it turns out to be something like this:

$c_1 = g^k \text{ (mod p)}$

$c_2 = A^k * m \text{ (mod p)}$

Decryption is around the same thing. It just reverses the encryption but let's analyze that too:

```py
def decrypt_setup(a, p):
    def decrypt(c1, c2):
        m = pow(c1, a, p)
        m = pow(m, -1, p)
        m = (c2 * m) % p

        return m

    return decrypt

decrypt = decrypt_setup(a, p)
m = decrypt((c1 * c1_) % p, (c2 * c2_) % p)
```

Breaking it down, it takes the private key `a` and the 2 ciphertexts. The server also allows us to submit 2 values such that they are multiplied by the 2 original ciphertexts and then decrypted. If only there was a way to decrypt the ciphertexts... Oh wait there is!

Notice how the decryption function works:

Part 1:

$$\begin{flalign}
c_1 = g^k = 2^k \newline 
c_2 = A^k * m = (2^a)^k * m = 2^{ak} * m 
\end{flalign}$$

Part 2:

$$\begin{flalign}
c_1^a = (2^k)^a = 2^{ak} \newline
(2^{ak})^{-1} = \frac{1}{2^{ak}} \newline 
\frac{1}{2^{ak}} * c_2 = \frac{1}{2^{ak}} * 2^{ak} * m = m
\end{flalign}$$

We can change this though. Since we are allowed to tweak c1 and c2 to whatever we want, we can set $c_1 = 2\*c_1$ and $c_2 = A\*c_2$.
How does this work? Well, let's look at the math:

$$\begin{flalign}
c_1^a = (2\*2^k)^a = 2^{a}\*2^{ak} \newline 
(2^{a}\*2^{ak})^{-1} = \frac{1}{2^{a}\*2^{ak}} \newline 
\frac{1}{2^{a}\*2^{ak}} * c_2 = \frac{1}{2^{a}\*2^{ak}} * (A*2^{ak}) * m = \frac{1}{2^{a}\*2^{ak}} * (2^{a}\*2^{ak}) * m = m
\end{flalign}$$

Thus, by submitting 2 as c1_ and A as c2_, we solve the challenge and obtain the flag!

## Flag

`uiuctf{h0m0m0rpi5sms_ar3_v3ry_fun!!11!!11!!}`
