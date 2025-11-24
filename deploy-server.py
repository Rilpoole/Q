import subprocess

cur_part = subprocess.run(["lsblk"], capture_output=True, text=True)
print(cur_part.stdout)

use_part = input("Which partitions would you like to deploy? ")
print(use_part.split(" "))