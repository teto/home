{ memento, flakeSelf }:
let
  memento-with-ocr = memento.override ({ withOcr = true; });
in
memento-with-ocr.overrideAttrs {
  pname = "memento-dev";
  src = flakeSelf.inputs.memento-dev;
}
