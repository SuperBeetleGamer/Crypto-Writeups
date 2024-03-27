# Flag_printer

By: SuperBeetleGamer

I made a program to solve a problem, but it seems too slow :(

## Solve

Dude... like... what the hell was this challenge...

Okay first things first, combing through the source code... here's what I gathered from an inital overview.

1. We are given a set of x,y coordinates
2. We are constructing a matrix with powers of consecutive integers
3. The answer vector are all the y values
4. We are solving for a vector whose values are all < 256 since it creates a bmp image
5. The source code is correct, its just too slow

Given this information, the conclusion was to find a polynomial that interpolates all points in the given file. 

Oh yeah simple! haha just use sages `.lagrange_polynomial()` and we're good to go. Okay challenge done.

Nah just kidding. BRO WHO MADE THE DEGREE OF THIS POLYNOMIAL 1.7 MILLION???

Sage is too slow with that. Time to find a better algorithm.

After a some googling, we stumbled on this blog: https://codeforces.com/blog/entry/82953

The most important part of this was the optimization section, where it tells us how to evaluate `f(X)` given **consecutive points** without finding the actual interpolated polynomial. But we can work around this by substituting in a variable instead of a number for X to recover `f`.

Sooooooooo sage implementation time.

Starting with the denominator, we need a fast way to calculate all those pesky factorials. Luckily, we are doing this over a finite field so the numbers are managable in size and sage can perform them fairly quickly. To speed it up further, each factorial was cached in a table for future use.

```py
MOD = 7514777789
F = GF(MOD)
factorials = [1] # 0!
for i in tqdm(range(n-1)):
    factorials.append(F(factorials[i] * (i+1)))
```

Then to get the denominators (just following the blog):

```py
denoms = []
for i in tqdm(range(len(points))):
    total = (-1)^((n-(i+1)) % 2)
    total *= factorials[n-(i+1)]
    total *= factorials[(i+1)-1]
    denoms.append(F(total)^-1)
```

We invert the denominators over GF(MOD) right now to save a bit more time. And we can multiply each of these inverted denominators by the y-values (as shown in the blog).

```py
fs = []
for i in points:
    fs.append(i[1])

mults = []
for a,b in zip(fs, denoms):
    mults.append(F(a*b))
```

This whole process allows us to recover multipliers before starting on the polynomial stuff.

Now for the numerators... :sob: ~~Bro who actually designed this~~

Notice how the numerators are basically just polynomial factorials minus 1 term.
```
x! = x * (x-1) * (x-2) * ... * (x-n)
```
where n is the number of points.

However, each numerator doesn't have a term in the factorial. For example, the j'th numerator should be:
`x * (x-1) * ... * (x-(j-1)) * (x-(j+1)) * ... * (x-n)`

So... in order to optimize this as well. Let's just evaluate `x!` and for every numerator, we just divide by the `(x-j)` term!. 

Uhh... that polynomial division takes so long :sob:. Like... HORRIBLY LONG. Whatever let's code it up first...

```py
P.<x> = PolynomialRing(GF(MOD))
f = product([x-i for i in range(len(points))])

final_poly = 0
for i in range(len(points)):
	frac = f / (x-i) * mults[i]
	final_poly += frac
print(final_poly)
```

Great!!! This should work... EXCEPT FOR THE FACT THIS STILL TAKES REALLY LONG. This is still a major speedup though. The original source code takes ~4000 hours on a single core on my computer. This implementation of mine takes ~81 hours on a single core.

So... guaranteed solution in 81 hours!!! Isn't that great? No... because if you're like my team who has gotten 4th in pico twice in a row with 4/5 of us being seniors... WE NEED A FLAG NOW. NOT IN 81 HOURS.

Wait did I mention 81 hours on a *single* core? What if... we have more cores...

Enter what I like to call: The Eth007 Monkey Brute Strategy.
![eth](eth.png)

Sooooo we ended up not being able to get the 360 core machine but we did get a 112 core machine. Thank you Google Cloud and thank you Eth007.

Still we have to parallize it so let's do that in the mean time. Notice how in the above code segment we are adding up a lot of "small" polynomials into a final polynomial. If we can split up this adding process and add multiple at once, then it'll speed up a lot more.

```py
def para(indexes):

    final_poly = 0
    for i in range(indexes[0], indexes[1]):
        frac = f / (x-i)
        frac *= mults[i]
        final_poly += frac
    return final_poly

if __name__ == "__main__":
    cores = 4 # This was on my local machine

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
    open('output.txt', 'w').write(str(polys))
```

On my local machine, this worked pretty well! This cut our run time from 81 hours down to ~20 hours. Okay now onto Gcloud. We had 112 cores to mess with so we just chucked 112 cores at it.

![L](string.png)

Oh... I guess converting a 1.7 million degree polynomial into a string was a bad idea...
We ended up having to rerun this program. HOWEVER THIS TIME. We replaced that line with:
```py
monomials = str(polys.numerator().list())
open("polytext.txt", "w").write(monomials)
```
because its faster in python for it to convert a really long list of ints to a string than a polynomial element.

Another grueling 2 hours later and a nap from 3am to 5am, we finally got all the coefficents. Then it was a simple convert all coefficients to bytes and create the BMP.

![flag](flag.png)

```py
a = open("polytext.txt").read()

a= a[1:-1].split()
a = [int(n.strip()[:-1]) for n in a]

open("out.bmp", "wb").write(bytes(a))
```

Output:

![flag](out.bmp)

## Flag
```
picoctf{i_do_hope_you_used_the_favorite_algorithm_of_every_engineering_student}
```

## Outro

Dude... What the hell was this challenge. Here are some of the screenshots.

![image](image.png)
![print](print.png)