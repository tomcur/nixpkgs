{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, setuptools-scm
, pytestCheckHook
, pytest-asyncio
, pytest-tornado
, pytestcov
, sqlalchemy
, tornado
, twisted
, mock
, trollius
, gevent
, six
, pytz
, tzlocal
, funcsigs
, futures
, setuptools
, isPy3k
}:

buildPythonPackage rec {
  pname = "APScheduler";
  version = "3.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1cab7f2521e107d07127b042155b632b7a1cd5e02c34be5a28ff62f77c900c6a";
  };

  buildInputs = [
    setuptools-scm
  ];

  checkInputs = [
    pytest-asyncio
    pytest-tornado
    pytestCheckHook
    pytestcov
    sqlalchemy
    tornado
    twisted
    mock
    gevent
  ] ++ lib.optionals (!isPy3k) [ trollius ];

  propagatedBuildInputs = [
    six
    pytz
    tzlocal
    funcsigs
    setuptools
  ] ++ lib.optional (!isPy3k) futures;

  disabledTests = lib.optionals stdenv.isDarwin [
    "test_submit_job"
    "test_max_instances"
  ];

  pythonImportsCheck = [ "apscheduler" ];

  meta = with lib; {
    description = "A Python library that lets you schedule your Python code to be executed";
    homepage = "https://github.com/agronholm/apscheduler";
    license = licenses.mit;
  };
}
