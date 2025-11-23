#!/usr/bin/env python3

import subprocess

result = subprocess.run(["parted", "-l"], capture_output=False, text=True)