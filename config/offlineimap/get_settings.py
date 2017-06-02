import subprocess

# mattator@gmail.com
def get_user (service):
    output = subprocess.check_output("keyring get gmail mattator")
    return output

# def get_pwd (service):
