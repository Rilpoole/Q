import subprocess

# Show current partitions
cur_part = subprocess.run(["lsblk", "-o", "NAME,SIZE,TYPE,MOUNTPOINT"], capture_output=True, text=True)
print(cur_part.stdout)

# Ask user for partitions to encrypt (space-separated)
use_part = input("Which partitions would you like to deploy? [sda, sdb,...]")
partitions = use_part.split()

for partition in partitions:
    try:
        subprocess.run(
            ["sudo", "cryptsetup", "luksFormat", f"/dev/{partition}"],
            check=True
        )
        print(f"/dev/{partition} has been encrypted successfully.")
    except subprocess.CalledProcessError:
        print(f"Failed to encrypt /dev/{partition}")
