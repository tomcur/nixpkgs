{ lib, stdenv
, fetch
, cmake
, llvm
, version
}:

stdenv.mkDerivation {
  pname = "lld";
  inherit version;

  src = fetch "lld" "1ah75rjly6747jk1zbwca3z0svr9b09ylgxd4x9ns721xir6sia6";

  nativeBuildInputs = [ cmake ];
  buildInputs = [ llvm ];

  outputs = [ "out" "dev" ];

  postInstall = ''
    moveToOutput include "$dev"
    moveToOutput lib "$dev"
  '';

  meta = {
    description = "The LLVM Linker";
    homepage    = "https://lld.llvm.org/";
    license     = lib.licenses.ncsa;
    platforms   = lib.platforms.all;
    badPlatforms = [ "x86_64-darwin" ];
  };
}
