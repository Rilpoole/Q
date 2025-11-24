import subprocess

class Server:

    @staticmethod
    def run(cmd, capture_output = True, check = True):
        try:
            subprocess.run(cmd,capture_output,check)
        except subprocess.CalledProcessError as e:
            print(e.stderr)


    @staticmethod
    def install_depend():
        Server.run(["apt","update","-y"])
        Server.run(["apt","upgrade","-y"])
        Server.run(["apt","install","python3-pip"])
        Server.run(["pip3","install","PyYaml"])

