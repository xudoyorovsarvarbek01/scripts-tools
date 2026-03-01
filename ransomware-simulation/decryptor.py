#!/usr/bin/env python3

import os
from cryptography.fernet import Fernet, InvalidToken

# Load key
try:
    with open("key.key", "rb") as key_file:
        key = key_file.read()
except Exception as e:
    print("Kalitni o‘qishda xatolik:", e)
    key = None

if key:
    fernet = Fernet(key)

    for root, dirs, files in os.walk("."):
        for file in files:

            if file == "key.key" or file == "encryptor.py" or file=="decryptor.py" or file == "crypt.py" or file == "decrypt.py":
                continue

            if file.endswith((".txt", ".pdf")):
                path = os.path.join(root, file)

                try:
                    with open(path, "rb") as f:
                        data = f.read()

                    decrypted = fernet.decrypt(data)

                    with open(path, "wb") as f:
                        f.write(decrypted)

                    print("Deshifrlangan:", path)

                except InvalidToken:
                    print("Noto‘g‘ri kalit yoki buzilgan fayl:", path)
                except Exception as e:
                    print("Xatolik:", path, "->", e)

    print("\nDeshifrlash tugadi.")
