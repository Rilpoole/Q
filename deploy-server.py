import subprocess

result = subprocess.run(["parted", "-l"], capture_output=True, text=True)