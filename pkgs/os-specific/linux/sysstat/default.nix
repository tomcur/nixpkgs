{ lib, stdenv, fetchurl, gettext, bzip2 }:

stdenv.mkDerivation rec {
  name = "sysstat-12.3.2";

  src = fetchurl {
    url = "http://pagesperso-orange.fr/sebastien.godard/${name}.tar.xz";
    sha256 = "0gaas16q2f7qmrv4sbqk2l2mrc7yr64s33bzw4094p59fkylm7k4";
  };

  buildInputs = [ gettext ];

  preConfigure = ''
    export PATH_CP=$(type -tp cp)
    export PATH_CHKCONFIG=/no-such-program
    export BZIP=${bzip2.bin}/bin/bzip2
    export SYSTEMCTL=systemctl
  '';

  makeFlags = [ "SYSCONFIG_DIR=$(out)/etc" "IGNORE_FILE_ATTRIBUTES=y" "CHOWN=true" ];
  installTargets = [ "install_base" "install_nls" "install_man" ];

  patches = [ ./install.patch ];

  meta = {
    homepage = "http://sebastien.godard.pagesperso-orange.fr/";
    description = "A collection of performance monitoring tools for Linux (such as sar, iostat and pidstat)";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.eelco ];
  };
}
