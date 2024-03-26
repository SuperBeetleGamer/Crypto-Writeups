# Custom encryption

By: SuperBeetleGamer

Can you get sense of this code file and write the function that will decode the given encrypted file content.

## Solve

Diffie hellman key exchange except we are simply given the private exponenets.

We can calculate `u` and `v` to get literally every value in the test function:
```py
v = pow(g,a,p)# = 43
u = pow(g,b,p)# = 8

key = pow(u,a,p)
b_key = pow(v,b,p)
shared_key = None
if key == b_key:
	shared_key = key
```

Okay now for the actual encryption... Firstly, the flag goes through a "dynamic_xor_encrypt".

```py
def dynamic_xor_encrypt(plaintext, text_key):
    cipher_text = ""
    key_length = len(text_key)
    for i, char in enumerate(plaintext[::-1]):
        key_char = text_key[i % key_length]
        encrypted_char = chr(ord(char) ^ ord(key_char))
        cipher_text += encrypted_char
    return cipher_text
```

It takes the plaintext, reverses it, and xors it by the a key character. To reverse this, just enumerate through the ciphertext and reverse it at the end to get back the plaintext:

```py
def dynamic_xor_decrypt(ciphertext, text_key):
    plaint_text = ""
    key_length = len(text_key)
    for i, char in enumerate(ciphertext):
        key_char = text_key[i % key_length]
        encrypted_char = chr(ord(char) ^ ord(key_char))
        plaint_text += encrypted_char
    return plaint_text[::-1]
```

Simple enough.

Now for the second part of the decryption process:

```py
def encrypt(plaintext, key):
    cipher = []
    for char in plaintext:
        cipher.append(((ord(char) * key*311)))
    return cipher
```

Every character in the plaintext is first turned into its corresponding ASCII value and then multipled by the `key * 311`. To decrypt, just divide each value by `key * 311` and turn it back into a character.

```py
def decrypt(ciphertext, key):
	plain = ""
	for num in ciphertext:
		plain += chr(num // (key*311))
	return plain
```

Now its just putting these 2 decrypt functions together and obtaining the flag.

## Flag
```
picoCTF{custom_d2cr0pt6d_8b41f976}
```