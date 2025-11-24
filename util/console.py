import subprocess

class Console:

    @staticmethod
    def run(cmd, print_arg = True, capture_output_arg = True, check_arg = True, text_arg = True):

        result = subprocess.run(cmd,capture_output=capture_output_arg, check=check_arg, text=text_arg)
        if print_arg and (result.stdout is not None):
            print(result.stdout) 
        return result

