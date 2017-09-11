import keyring

def get_pass (service, name):
    v = keyring.get_password(service, name)
    # print("TEEESSTTT", v)
    # print("type", type(v))
    return v

