{ lib, buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "kapp";
  version = "0.36.0";

  src = fetchFromGitHub {
    owner = "vmware-tanzu";
    repo = "carvel-kapp";
    rev = "v${version}";
    sha256 = "sha256-hYKRfAnpHw8hHT70sOQSGlDj0dgzU0wlZpXA5f2BBfg=";
  };

  vendorSha256 = null;

  subPackages = [ "cmd/kapp" ];

  meta = with lib; {
    description = "CLI tool that encourages Kubernetes users to manage bulk resources with an application abstraction for grouping";
    homepage = "https://get-kapp.io";
    license = licenses.asl20;
    maintainers = with maintainers; [ brodes ];
  };
}
