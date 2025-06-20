{ buildNpmPackage, nodejs }:
let 
  src = ;
in
buildNpmPackage {
pname = "mcp-hub";
version = "3.4.3";
src = self;
inherit nodejs;

nativeBuildInputs = [nodejs];
npmDepsHash = "sha256-hcSW0go1pN3BjLSQcKKEmSnuy2KEcmhZTrL305s6OqM=";
}
