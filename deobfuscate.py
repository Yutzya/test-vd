#!/usr/bin/env python3
import re

# Read obfuscated file
with open('download.txt', 'r', encoding='utf-8', errors='ignore') as f:
    content = f.read()

# Decode octal escape sequences
def decode_octal(match):
    octal_str = match.group(1)
    return chr(int(octal_str, 8))

decoded = re.sub(r'\\(\d{1,3})', decode_octal, content)

# Decode hex escape sequences
def decode_hex(match):
    hex_str = match.group(1)
    return chr(int(hex_str, 16))

decoded = re.sub(r'\\x([0-9a-fA-F]{2})', decode_hex, decoded)

# Write decoded output
with open('download_decoded.txt', 'w', encoding='utf-8') as f:
    f.write(decoded)

print("✓ Deobfuscation complete!")
print(f"Output: download_decoded.txt")
print(f"Size: {len(decoded)} bytes")
