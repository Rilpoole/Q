import subprocess

class Console:

    @staticmethod
    def run(cmd, capture_output_arg = True, check_arg = True, text_arg = True):

        result = subprocess.run(cmd,capture_output=capture_output_arg, check=check_arg, text=text_arg)
        return result

