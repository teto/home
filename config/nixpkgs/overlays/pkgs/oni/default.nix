{ stdenv, runCommand, electron, callPackage,
  bash, python, jq, nodejs-8_x, node? nodejs-8_x, neovim, ripgrep, xorg,
 ...}: 
let 
    yarn2nix = callPackage ( builtins.fetchTarball { 
        url = "https://github.com/phryneas/yarn2nix/archive/8a6b9dcf7cef8840eb7bc64d7639bad566af2e9d.tar.gz " ;
        sha256 = "0ih11vcd9ad5y13877bxz7ijsykhqwdfwmvwhic3xlgcdhxji80v";
    }) {};
    version = "v0.3.6";
    oniSrc = builtins.fetchTarball { 
        url = "https://github.com/onivim/oni/archive/${version}.tar.gz" ;
        sha256 = "10rfm5kxwim6010jhg8v0jz5s2mndb34vgx8bd083a9givlib9v4";
    };
in
yarn2nix.mkYarnPackage rec {
    name = "oni";
    inherit version;
    src = oniSrc;

    patches = [
        ./yarn.lock.patch
    ];
    propagatedBuildInputs = [ xorg.libX11 xorg.libxkbfile ];
    nativeBuildInputs = [ python ];

    yarnLock = runCommand "yarn.lock" {} ''
    cp ${src}/yarn.lock .
    patch -p1 < ${./yarn.lock.patch}
    cat yarn.lock > $out
    '';

    postPatch = ''
    #sed -i 's/"build:plugins": .*$/"build:plugins": "true",/' package.json

    pushd vim/core/oni-plugin-typescript
        sed -i 's/npm install &&//' package.json
        sed -i '/"declaration":/s/true/false/' tsconfig.json
        find . -name \*.ts -exec sed -i 's|"./../../../../node_modules|"./../../../../../../node_modules|g' {} +
    popd
    '';

    postConfigure = ''
    rm .yarnrc

    pushd node_modules/keyboard-layout
        nodeVersion="`"${node}/bin/node" --version`"
        installVersion="`${jq}/bin/jq .installVersion "${node}/lib/node_modules/npm/node_modules/node-gyp/package.json"`"

        mkdir ''${nodeVersion#v}
        ln -s "${node}/include" ''${nodeVersion#v}/include
        echo "$installVersion" > ''${nodeVersion#v}/installVersion

        ${node}/lib/node_modules/npm/bin/node-gyp-bin/node-gyp --devdir $PWD configure
        ${node}/lib/node_modules/npm/bin/node-gyp-bin/node-gyp --devdir $PWD build
    popd
    '';

    buildPhase = ''
    PATH=$PATH:$(pwd)/node_modules/.bin
    pushd deps/${name}
        yarn build
    popd
    '';

    postInstall = ''
    cat <<EOF > $out/bin/oni
    #!${bash}/bin/bash
    PATH=${ stdenv.lib.makeBinPath [ electron python node neovim ripgrep ] }
    electron "$out/libexec/${name}/deps/${name}/lib/main/src/main.js"
    EOF
    chmod +x $out/bin/oni
    '';
}
