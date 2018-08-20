{ stdenv, runCommand, llvm, clang, kernel_headers }:


# this stdenv belongs to clang
stdenv.mkDerivation  { 
  name = "ebpfdropper";
  version = "0.1";

  buildInputs =  [ 
    # kernel_headers
    llvm # for llc
  ]; 

  src = ./ebpfdropper;

  # to prevent
  # error: <unknown>:0:0: in function handle_ingress i32 (%struct.__sk_buff*): A call to built-in function '__stack_chk_fail' is not supported.
  hardeningDisable=["all"];

  unpackPhase = ":";

  buildPhase = ''
    clang -O2 -emit-llvm -c $src/test_ebpf_tc.c -o - | llc -march=bpf -filetype=obj -o bpf.o
  '';

  installPhase = ''

    echo $PWD
    mkdir $out
    mv ./* $out/

  '';
}

