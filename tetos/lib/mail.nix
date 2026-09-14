{
  # config,
  # lib,
  pkgs,
  ...
}:
{
  # --read-envelope-from 
  defaultSendMailCommand = "${pkgs.msmtp}/bin/msmtpq --debug --read-recipients";


}
