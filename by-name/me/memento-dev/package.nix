{ memento, flakeSelf }:
let
  memento-with-ocr = memento.override ({ withOcr = true; });
in
memento-with-ocr.overrideAttrs {
  src = flakeSelf.inputs.memento-dev;
}
