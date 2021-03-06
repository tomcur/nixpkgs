{ lib, stdenv, fetchurl, which, libao, pkg-config }:

let
  version = "2.13";
in stdenv.mkDerivation {
  pname = "uade123";
  inherit version;
  src = fetchurl {
    url = "http://zakalwe.fi/uade/uade2/uade-${version}.tar.bz2";
    sha256 = "04nn5li7xy4g5ysyjjngmv5d3ibxppkbb86m10vrvadzxdd4w69v";
  };
  nativeBuildInputs = [ pkg-config which ];
  buildInputs = [ libao ];

  enableParallelBuilding = true;
  hardeningDisable = [ "format" ];

  meta = with lib; {
    description = "Plays old Amiga tunes through UAE emulation and cloned m68k-assembler Eagleplayer API";
    homepage = "http://zakalwe.fi/uade/";
    license = licenses.gpl2;
    maintainers = [ lib.maintainers.gnidorah ];
    platforms = lib.platforms.unix;
  };
}
