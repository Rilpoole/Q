#!/usr/bin/env python3

import subprocess

cur_part = subprocess.run(["lsblk"], capture_output=True, text=True)
print(cur_part.stdout)

use_part = input("Which partitions would you like to use?")
print(use_part)