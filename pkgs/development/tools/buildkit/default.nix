{ lib, stdenv, fetchFromGitHub, buildGoPackage }:

buildGoPackage rec {
  pname = "buildkit";
  version = "0.8.2";

  goPackagePath = "github.com/moby/buildkit";
  subPackages = [ "cmd/buildctl" ] ++ lib.optionals stdenv.isLinux [ "cmd/buildkitd" ];

  src = fetchFromGitHub {
    owner = "moby";
    repo = "buildkit";
    rev = "v${version}";
    sha256 = "sha256-aPVroqpR4ynfHhjJ6jJX6y5cdgmoUny3A8GBhnooOeo=";
  };

  buildFlagsArray = [ "-ldflags=-s -w -X ${goPackagePath}/version.Version=${version} -X ${goPackagePath}/version.Revision=${src.rev}" ];

  meta = with lib; {
    description = "Concurrent, cache-efficient, and Dockerfile-agnostic builder toolkit";
    homepage = "https://github.com/moby/buildkit";
    license = licenses.asl20;
    maintainers = with maintainers; [ vdemeester marsam ];
  };
}
