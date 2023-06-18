# Login
By: SuperBeetleGamer (SBG)

## Description

can you login this service?

`nc 13.124.163.225 8282`

## Solve

After the competition ended, I was notified that this chall was literally an exact copy of the CryptoCTF "salt and pepper". But, we won't be going over that since I solved it my own way cuz I COULDN'T GET HASHPUMPY TO WORK ON PYTHON. Anyways.

Okay, let's analyze `chall.py`. At the first glance, we know its going to hash length extension. Why? Well:

```py
USER_ID = generate_random_string(8)
USER_PW = generate_random_string(8)
id_key = generate_random_string(20)
pw_key = generate_random_string(20)
show(f"USER_ID = {USER_ID.decode()}")
show(f"USER_PW = {USER_PW.decode()}")
show("")
show(f"md5(id_key) = {md5(id_key).hexdigest()}")
show(f"sha1(pw_key) = {sha1(pw_key).hexdigest()}")
```

C'mon now. This is hash length extension. Okay let's list these in an easier format to see what we've got:

```
USER_ID
USER_PW
MD5(id_key)
SHA1(pw_key)
```

Nice. That seems fine. Now how do we get the flag? 

```py
user_data = input()
user_id, user_pw = [bytes.fromhex(data) for data in user_data.split(":")]
if USER_ID in user_id and USER_PW in user_pw:
    result = input()
    if auth_check(id_key, pw_key, user_id, user_pw, result):
        flag = read_flag()
        show(f"login sucess!!\nflag is {flag}")
    else:
        show("login fail..")
        quit()
```

Okay, so they ask us for the USER_PW and USER_ID and a hash. It performs an auth_check() on those values and if our hash matches with the results of the auth check, then we win! Okay let's analyze the auth check:

```py
def auth_check(id_key, pw_key, user_id, user_pw, result):
    return sha1(pw_key + user_pw + md5(id_key + user_id).hexdigest().encode("utf-8")).hexdigest() == result
```

Hmmmmm thats a bad format. Let's clear is up a little:

```
SHA1(pw_key + user_pw + MD5(id_key + user_id))
```

Okay thats clearer. There's an attack called the [Hash Length Extension](https://en.wikipedia.org/wiki/Length_extension_attack) attack. The main thing you need to understand is that when hashing, the "plaintext" is split up into blocks and the hash is updated block by block. In this case, let's assume that id_key is the first block. id_key would be hashed and the hash would move on to the user_id block.

This means that we can continue hashing and get the MD5 hash of id_key + user_id without ever knowing what id_key was! There's a useful tool to do this and I used hashpump. 

Hashpump basically allows you to perform hash length extension attacks without the need of implementing everthing yourself. Helpful tool. So, let's get working. This was done in my linux vm. I patched the tool so that it wouldn't need a `-d` flag.

```
./hashpump -s "md5 hash here" -a "USER_ID" -k 20
```
We have a length of 20 because that's how long the id_key was. This get's us an MD5 hash of the first part without ever knowing the the id_key!.
Now let's do the sha1 part.

```
./hashpump -s "sha1 hash here" -a "USER_PW + md5 hash that it spit out by the last command" -k 20
```

This will get us the final hash with the with everything combined and we can send that to the server. The login info can be formatted and submitted based on the output from the hashpump commands. 

Note: The output from the sha1 command of the plaintext must be cropped a little bit because of the md5 hash.

Thus, we just submit those and get the flag! 

ps. I didn't use a solve script for this. Everything was done on my terminal.

## Flag

I didn't have a solve script for this since I did everything in the terminal. If you need more information for this writeup please let me know.

