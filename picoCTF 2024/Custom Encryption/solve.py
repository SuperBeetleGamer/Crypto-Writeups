def decrypt(ciphertext, key):
	plain = ""
	for num in ciphertext:
		plain += chr(num // (key*311))
	return plain

def dynamic_xor_decrypt(ciphertext, text_key):
    plaint_text = ""
    key_length = len(text_key)
    for i, char in enumerate(ciphertext):
        key_char = text_key[i % key_length]
        encrypted_char = chr(ord(char) ^ ord(key_char))
        plaint_text += encrypted_char
    return plaint_text[::-1]

cipher = [131553, 993956, 964722, 1359381, 43851, 1169360, 950105, 321574, 1081658, 613914, 0, 1213211, 306957, 73085, 993956, 0, 321574, 1257062, 14617, 906254, 350808, 394659, 87702, 87702, 248489, 87702, 380042, 745467, 467744, 716233, 380042, 102319, 175404, 248489]
a = 94
b = 21
p = 97
g = 31

v = pow(g,a,p)
u = pow(g,b,p)

key = pow(u,a,p)
b_key = pow(v,b,p)
shared_key = None
if key == b_key:
	shared_key = key

text_key = "trudeau" # Given in source

flag = dynamic_xor_decrypt(decrypt(cipher, shared_key), text_key)
print(flag)