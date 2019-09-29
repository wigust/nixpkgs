{ stdenv
, buildPythonPackage
, fetchPypi
, tornado
, requests
, httplib2
, sure
, nose
, coverage
, certifi
, urllib3
, rednose
, nose-randomly
, six
, mock
}:

buildPythonPackage rec {
  pname = "httpretty";
  version = "0.8.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0f295zj272plr9lhf80kgz19dxkargwv3ar83rwavrcy516mgg9n";
  };

  checkInputs = [ nose sure coverage mock rednose
  # Following not declared in setup.py
    nose-randomly requests tornado httplib2
  ];
  propagatedBuildInputs = [ six ];

  __darwinAllowLocalNetworking = true;

  doCheck = false;

  meta = with stdenv.lib; {
    homepage = "https://falcao.it/HTTPretty/";
    description = "HTTP client request mocking tool";
    license = licenses.mit;
  };

}
