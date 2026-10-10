{ immich }:
immich.overrideAttrs {
    # # overrides
    # hideBuyButton ? false,
    postPatch = ''
      substituteInPlace src/lib/components/shared-components/side-bar/purchase-info.svelte \
        --replace-fail "showBuyButton = getButtonVisibility()" "showBuyButton = false"
    '';
  }

