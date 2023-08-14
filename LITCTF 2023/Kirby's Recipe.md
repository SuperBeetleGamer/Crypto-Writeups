# Kirby's Recipe

By: SuperBeetleGamer

yum kirby

## Solve

Who cares about solving it the right way? Let's just social engineer the admins instead!

Note: This is an unintended solution

We get an html file with a lot of what looked to me like ciphers and encodings. Each of those can be solved by either chucking it into dcode or a base converter into ASCII.

We also get another password protected zip file meaning that the password is most likely hiding somewhere in the html. Here's the thing, I was supposed to decode each one which had a character of the password in it. Unfortunately, I didn't really know that.

Here's how I did it.

Take this base64 encoded string from the html:
```
UCBBcyB0aGUgc291cCB3YXMgcmVhZHksIG15IGdyYW5kbW90aGVyIGxhZGxlZCBpdCBpbnRvIGJvd2xzIGFuZCBoYW5kZWQgdGhlbSB0byB1cyB3aXRoIGEgc21pbGUuIEkgdG9vayBhIHNpcCBhbmQgd2FzIGJsb3duIGF3YXkgYnkgdGhlIGZsYXZvcnMuIEl0IHdhcyB0aGUgYmVzdCB2ZWdldGFibGUgc291cCBJIGhhZCBldmVyIHRhc3RlZC4gSSBhc2tlZCBteSBncmFuZG1vdGhlciBpZiBzaGUgY291bGQgdGVhY2ggbWUgaG93IHRvIG1ha2UgaXQsIGFuZCBzaGUgYWdyZWVkLiBLZXkgPSBLZXk=
```
And convert it to ASCII to get:
```
P As the soup was ready, my grandmother ladled it into bowls and handed them to us with a smile. I took a sip and was blown away by the flavors. It was the best vegetable soup I had ever tasted. I asked my grandmother if she could teach me how to make it, and she agreed. Key = Key
```

Oh look! Key = Key. In my head, I thought `Key` was the password which I tried. Surprisingly, the password protected zip unzipped! It seemed to be a corrupted png. Looking further, I didn't notice anything wrong. I mean... The zip uncompressed fine.

Time to ask the admins! Moments before disaster:

![](https://github.com/SuperBeetleGamer/Crypto-Writeups/blob/main/LITCTF%202023/Screen%20Shot%202023-08-12%20at%2010.45.43%20PM.png)
![](https://github.com/SuperBeetleGamer/Crypto-Writeups/blob/main/LITCTF%202023/Screen%20Shot%202023-08-12%20at%2010.46.30%20PM.png)

So we get the fully uncompressed zip on our end. After that, it's a simple `zsteg -a kirbycooking.png | grep LITCTF{`

## Flag

`LITCTF{s0up_fr0m_k1rby!2!3}`
