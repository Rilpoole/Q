from util import Console
import subprocess
import random
import json

print("Starting server deploy script...")
Console.run(["lsblk"])
parts = input("What partitions would you like to deploy? [sda, sdb, ...]").split(" ")

keys = []
for part in parts:
    keys.append((part,random.randint(1e32,1e33-1)))
    
with open("luks.out","w") as file:
    file.write(json.dumps(keys))