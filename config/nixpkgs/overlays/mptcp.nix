self: super:
{

  # todo bump the linux mptcp one
  mptcp-dev = super.linux_mptcp.overrideAttrs (oldAttrs: {
  #   propagatedBuildInputs = with super.pythonPackages; oldAttrs.propagatedBuildInputs ++ [ keyring secretstorage pygobject3 pygobject2 ];
    src = /home/teto/mptcp;
    # patches are for security, makes dev harder
    kernelPatches = [];
  });
}

