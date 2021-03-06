{ buildPythonPackage
, lib
, fetchFromGitHub
, pythonOlder
, cookiecutter
, filelock
, importlib-metadata
, regex
, requests
, numpy
, protobuf
, sacremoses
, tokenizers
, tqdm
}:

buildPythonPackage rec {
  pname = "transformers";
  version = "4.3.3";

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-KII7ZR+vnCxCxUcBOQo9y0KxZa+XuIIAkSJejk8HrlA=";
  };

  propagatedBuildInputs = [
    cookiecutter
    filelock
    numpy
    protobuf
    regex
    requests
    sacremoses
    tokenizers
    tqdm
  ] ++ lib.optionals (pythonOlder "3.8") [ importlib-metadata ];

  # Many tests require internet access.
  doCheck = false;

  postPatch = ''
    sed -ri 's/tokenizers[=>]=[^"]+/tokenizers/g' setup.py src/transformers/dependency_versions_table.py
  '';

  pythonImportsCheck = [ "transformers" ];

  meta = with lib; {
    homepage = "https://github.com/huggingface/transformers";
    description = "State-of-the-art Natural Language Processing for TensorFlow 2.0 and PyTorch";
    changelog = "https://github.com/huggingface/transformers/releases/tag/v${version}";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ danieldk pashashocky ];
  };
}
