{ stdenv, runCommand, llvm, clang }:


# this stdenv belongs to clang
stdenv.mkDerivation  { 
  name = "ebpfdropper";
  version = "0.1";

  buildInputs =  [ 
    llvm # for llc
  ]; 

  src = ./ebpfdropper;

  # to prevent
  # error: <unknown>:0:0: in function handle_ingress i32 (%struct.__sk_buff*): A call to built-in function '__stack_chk_fail' is not supported.
  hardeningDisable=["all"];

  unpackPhase = ":";

  buildPhase = ''
    clang -O2 -emit-llvm -c $src/ebpf_dropper.c -o - | llc -march=bpf -filetype=obj -o ebpf_dropper.o
  '';

  shellHook = ''
    echo $buildPhase
  '';
  installPhase = ''

    echo $PWD
    mkdir $out
    mv ./* $out/

  '';
}

