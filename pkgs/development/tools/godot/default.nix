{ stdenv, lib, fetchFromGitHub, scons, pkg-config, libX11, libXcursor
, libXinerama, libXrandr, libXrender, libpulseaudio ? null
, libXi ? null, libXext, libXfixes, freetype, openssl
, alsaLib, libGLU, zlib, yasm ? null }:

let
  options = {
    touch = libXi != null;
    pulseaudio = false;
  };
in stdenv.mkDerivation rec {
  pname = "godot";
  version = "3.2.3";

  src = fetchFromGitHub {
    owner  = "godotengine";
    repo   = "godot";
    rev    = "${version}-stable";
    sha256 = "19vrp5lhyvxbm6wjxzn28sn3i0s8j08ca7nani8l1nrhvlc8wi0v";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    scons libX11 libXcursor libXinerama libXrandr libXrender
    libXi libXext libXfixes freetype openssl alsaLib libpulseaudio
    libGLU zlib yasm
  ];

  patches = [
    ./pkg_config_additions.patch
    ./dont_clobber_environment.patch
  ];

  enableParallelBuilding = true;

  sconsFlags = "target=release_debug platform=x11";
  preConfigure = ''
    sconsFlags+=" ${lib.concatStringsSep " " (lib.mapAttrsToList (k: v: "${k}=${builtins.toJSON v}") options)}"
  '';

  outputs = [ "out" "dev" "man" ];

  installPhase = ''
    mkdir -p "$out/bin"
    cp bin/godot.* $out/bin/godot

    mkdir "$dev"
    cp -r modules/gdnative/include $dev

    mkdir -p "$man/share/man/man6"
    cp misc/dist/linux/godot.6 "$man/share/man/man6/"

    mkdir -p "$out"/share/{applications,icons/hicolor/scalable/apps}
    cp misc/dist/linux/org.godotengine.Godot.desktop "$out/share/applications/"
    cp icon.svg "$out/share/icons/hicolor/scalable/apps/godot.svg"
    cp icon.png "$out/share/icons/godot.png"
    substituteInPlace "$out/share/applications/org.godotengine.Godot.desktop" \
      --replace "Exec=godot" "Exec=$out/bin/godot"
  '';

  meta = with lib; {
    homepage    = "https://godotengine.org";
    description = "Free and Open Source 2D and 3D game engine";
    license     = licenses.mit;
    platforms   = [ "i686-linux" "x86_64-linux" ];
    maintainers = with maintainers; [ twey ];
  };
}
