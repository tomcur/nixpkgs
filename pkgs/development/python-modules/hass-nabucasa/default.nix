{ lib
, acme
, aiohttp
, asynctest
, atomicwrites
, attrs
, buildPythonPackage
, fetchFromGitHub
, pycognito
, pytest-aiohttp
, pytestCheckHook
, snitun
, warrant
}:

buildPythonPackage rec {
  pname = "hass-nabucasa";
  version = "0.42.0";

  src = fetchFromGitHub {
    owner = "nabucasa";
    repo = pname;
    rev = version;
    sha256 = "sha256-vDgjuNgwNp9cDgiCNxhACOcuaxcrR+0DW/U5OaSW0n4=";
  };

  postPatch = ''
    sed -i 's/"acme.*"/"acme"/' setup.py
  '';

  propagatedBuildInputs = [
    acme
    aiohttp
    atomicwrites
    attrs
    pycognito
    snitun
    warrant
  ];

  checkInputs = [
    asynctest
    pytest-aiohttp
    pytestCheckHook
  ];

  pythonImportsCheck = [ "hass_nabucasa" ];

  meta = with lib; {
    homepage = "https://github.com/NabuCasa/hass-nabucasa";
    description = "Home Assistant cloud integration by Nabu Casa, inc.";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ Scriptkiddi ];
  };
}
