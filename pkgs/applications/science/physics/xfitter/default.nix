{ lib, stdenv, fetchurl, apfel, apfelgrid, applgrid, blas, gfortran, lhapdf, lapack, libyaml, lynx
, mela, root5, qcdnum, which, libtirpc
}:

stdenv.mkDerivation rec {
  pname = "xfitter";
  version = "2.0.1";

  src = fetchurl {
    name = "${pname}-${version}.tgz";
    url = "https://www.xfitter.org/xFitter/xFitter/DownloadPage?action=AttachFile&do=get&target=${pname}-${version}.tgz";
    sha256 = "0kmgc67nw5flp92yw5x6l2vsnhwsfi5z2a20404anisdgdjs8zc6";
  };

  patches = [
    ./undefined_behavior.patch
  ];

  # patch needs to updated due to version bump
  #CXXFLAGS = "-Werror=return-type";

  preConfigure =
  # Fix F77LD to workaround for a following build error:
  #
  #   gfortran: error: unrecognized command line option '-stdlib=libc++'
  #
    lib.optionalString stdenv.isDarwin ''
      substituteInPlace src/Makefile.in \
        --replace "F77LD = \$(F77)" "F77LD = \$(CXXLD)" \
    '';

  configureFlags = [
    "--enable-apfel"
    "--enable-apfelgrid"
    "--enable-applgrid"
    "--enable-mela"
    "--enable-lhapdf"
  ];

  nativeBuildInputs = [ gfortran which ];
  buildInputs =
    [ apfel apfelgrid applgrid blas lhapdf lapack mela root5 qcdnum libtirpc ]
    # pdf2yaml requires fmemopen and open_memstream which are not readily available on Darwin
    ++ lib.optional (!stdenv.isDarwin) libyaml
    ;
  propagatedBuildInputs = [ lynx ];

  enableParallelBuilding = true;

  hardeningDisable = [ "format" ];

  NIX_CFLAGS_COMPILE = [ "-I${libtirpc.dev}/include/tirpc" ];
  NIX_LDFLAGS = [ "-ltirpc" ];

  meta = with lib; {
    description = "The xFitter project is an open source QCD fit framework ready to extract PDFs and assess the impact of new data";
    license     = licenses.gpl3;
    homepage    = "https://www.xfitter.org/xFitter";
    platforms   = platforms.unix;
    maintainers = with maintainers; [ veprbl ];
  };
}
