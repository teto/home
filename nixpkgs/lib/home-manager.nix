# { }:
# {
#           home-manager.verbose = true;
#           # install through the use of user.users.USER.packages
#           home-manager.useUserPackages = true;
#           # disables the Home Manager option nixpkgs.*
#           home-manager.useGlobalPkgs = true;
#           home-manager.extraSpecialArgs = {
#             inherit secrets;
# 			flakeInputs = self.inputs;
#           };
#          }
