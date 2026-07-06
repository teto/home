{ memento, flakeSelf }:
memento.overrideAttrs {
  src = flakeSelf.inputs.memento-dev;
}
