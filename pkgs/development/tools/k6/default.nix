{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "k6";
  version = "0.31.0";

  goPackagePath = "github.com/loadimpact/k6";

  src = fetchFromGitHub {
    owner = "loadimpact";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-UAVbYN4uDUMqUspycEZ2VGHzxFD7IlIW6m91U8ccZXw=";
  };

  subPackages = [ "./" ];

  meta = with lib; {
    description = "A modern load testing tool, using Go and JavaScript";
    homepage = "https://k6.io/";
    changelog = "https://github.com/loadimpact/k6/releases/tag/v${version}";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ offline ];
  };
}
