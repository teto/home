{ zeal }:
zeal.overrideAttrs (oa: {

            # export QMLSCENE_DEVICE=software
            postInstall = ''
              wrapProgram $out/bin/zeal --set-default QMLSCENE_DEVICE software
            '';

          })

