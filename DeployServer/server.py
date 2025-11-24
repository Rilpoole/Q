import subprocess

class Server:

    @staticmethod
    def install_depend():
        subprocess.run(["apt","update"], check=True)
        subprocess.run(["apt","install","python3-pip"],check=True)
        subprocess.run(["pip3","install","PyYaml"], check=True)

