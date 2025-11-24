from util import Console
import subprocess
import random
import json

print("Starting server deploy script...")
Console.run(["lsblk"])
parts = input("What partitions would you like to deploy? [sda, sdb, ...]").split(" ")

keys = []
for part in parts:
    keys.append((part,random.randbytes(128)))
    
with open("luks.out","w") as file:
    file.write(json.dumps(keys))