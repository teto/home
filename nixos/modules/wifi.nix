{ config, lib, pkgs,  ... }:
{
# https://wireless.wiki.kernel.org/en/developers/Regulatory/CRDA#Using_iw_to_change_regulatory_domains

# https://renaudcerrato.github.io/2016/05/30/build-your-homemade-router-part3/
# https://wireless.wiki.kernel.org/en/developers/regulatory/processing_rules

# Liste des codes country
# if you get country 00, it means world/global =>
# http://en.wikipedia.org/wiki/ISO_3166-1_alpha-2
# iwlist wlan0 freq
# iw reg set US

environment.systemPackages = with pkgs; [
  crda
  iw
  wavemon
];
}
