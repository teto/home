{ mokuro, flakeSelf }:
mokuro.overrideAttrs { 
  src = flakeSelf.inputs.mokuro;
}
