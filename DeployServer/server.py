import subprocess

class Server:

    @staticmethod
    def run(cmd, capture_output_arg=True, check_arg=True, text_arg=True):
        print(f"Running command: {' '.join(cmd)}")
        try:
            result = subprocess.run(cmd, capture_output=capture_output_arg, check=check_arg, text=text_arg)
            print(result.stdout if result.stdout else "")
            print(result.stderr if result.stderr else "")
            return result
        except subprocess.CalledProcessError as e:
            print("Command failed!")
            if e.stdout:
                print("STDOUT:", e.stdout)
            if e.stderr:
                print("STDERR:", e.stderr)
            return None

    @staticmethod
    def install_depend():
        Server.run(["sudo", "apt", "update"])
        Server.run(["sudo", "apt", "upgrade", "-y"])
        Server.run(["sudo", "apt", "install", "python3-pip", "-y"])
        Server.run(["pip3", "install", "PyYAML"])
