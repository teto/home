{ pkgs, ... }:
{


  environment.systemPackages = [       
    pkgs.docling
    pkgs.docling-serve
 ];

  services.docling-serve = {
    enable = true;
    openFirewall = true;
    # "docling-serve run --enable-ui"
    # port = 
    #  environment is appended to {
        # HF_HOME = ".";
        # EASYOCR_MODULE_PATH = ".";
        # MPLCONFIGDIR = ".";
    # }
    environment = {
    DOCLING_SERVE_ENABLE_UI = "True";
  };
 };
}
