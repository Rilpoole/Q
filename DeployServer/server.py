import subprocess

class Server:

    @staticmethod
    def run(cmd, capture_output = True, check = True, text = True):
        try:
            subprocess.run(cmd,capture_output,check,text)
        except subprocess.CalledProcessError as e:
            print(e.stderr)


    @staticmethod
    def install_depend():
        Server.run(["apt","update"])
        Server.run(["apt","upgrade","-y"])
        Server.run(["apt","install","python3-pip","-y"])
        Server.run(["pip3","install","PyYaml","-y"])

