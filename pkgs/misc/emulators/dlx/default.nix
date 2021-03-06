{ lib, stdenv, fetchurl, unzip }:

stdenv.mkDerivation {
  name = "dlx-2012.07.08";

  src = fetchurl {
    url = "https://www.davidviner.com/zip/dlx/dlx.zip";
    sha256 = "0q5hildq2xcig7yrqi26n7fqlanyssjirm7swy2a9icfxpppfpkn";
  };

  nativeBuildInputs = [ unzip ];

  makeFlags = [ "CC=${stdenv.cc.targetPrefix}cc" "LINK=${stdenv.cc.targetPrefix}cc" "CFLAGS=-O2" ];

  hardeningDisable = [ "format" ];

  installPhase = ''
    mkdir -p $out/include/dlx $out/share/dlx/{examples,doc} $out/bin
    mv -v masm mon dasm $out/bin/
    mv -v *.i auto.a $out/include/dlx/
    mv -v *.a *.m $out/share/dlx/examples/
    mv -v README.txt MANUAL.TXT $out/share/dlx/doc/
  '';

  meta = {
    homepage = "http://www.davidviner.com/dlx.php";
    description = "DLX Simulator";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.all;
  };
}
