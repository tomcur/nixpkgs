{ version
, srcName
, sha256
}:

{ stdenv
, lib
, cudatoolkit
, fetchurl
, addOpenGLRunpath
}:

stdenv.mkDerivation {
  name = "cudatoolkit-${cudatoolkit.majorVersion}-cudnn-${version}";

  inherit version;
  src = fetchurl {
    # URL from NVIDIA docker containers: https://gitlab.com/nvidia/cuda/blob/centos7/7.0/runtime/cudnn4/Dockerfile
    url = "https://developer.download.nvidia.com/compute/redist/cudnn/v${version}/${srcName}";
    inherit sha256;
  };

  nativeBuildInputs = [ addOpenGLRunpath ];

  installPhase = ''
    function fixRunPath {
      p=$(patchelf --print-rpath $1)
      patchelf --set-rpath "''${p:+$p:}${lib.makeLibraryPath [ stdenv.cc.cc ]}:\$ORIGIN/" $1
    }

    for lib in lib64/lib*.so; do
      fixRunPath $lib
    done

    mkdir -p $out
    cp -a include $out/include
    cp -a lib64 $out/lib64
  '';

  # Set RUNPATH so that libcuda in /run/opengl-driver(-32)/lib can be found.
  # See the explanation in addOpenGLRunpath.
  postFixup = ''
    for lib in $out/lib/lib*.so; do
      addOpenGLRunpath $lib
    done
  '';

  propagatedBuildInputs = [
    cudatoolkit
  ];

  passthru = {
    inherit cudatoolkit;
    majorVersion = lib.versions.major version;
  };

  meta = with lib; {
    description = "NVIDIA CUDA Deep Neural Network library (cuDNN)";
    homepage = "https://developer.nvidia.com/cudnn";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ mdaiter ];
  };
}
