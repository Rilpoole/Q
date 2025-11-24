import subprocess
import tempfile

password = input("Enter password to use for encryption: ")

# create temporary key file
with tempfile.NamedTemporaryFile(mode='w', delete=False) as f:
    f.write(password)
    key_file = f.name

for partition in partitions:
    try:
        subprocess.run(
            ["sudo", "cryptsetup", "luksFormat", "/dev/" + partition,
             "--batch-mode", "--key-file", key_file],
            check=True
        )
        print(f"/dev/{partition} has been encrypted successfully.")
    except subprocess.CalledProcessError:
        print(f"Failed to encrypt /dev/{partition}")
