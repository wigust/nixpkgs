{ stdenv, buildPythonPackage, fetchPypi, lib, requests, python3Packages, simplejson, configobj }:

buildPythonPackage rec {
  pname = "protobix";
  version = "1.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1nq4qmpy38sd2lnjdcfjwfv0w3gqncvjnbqb6v57zf7kgb3rwkv4";
  };

  propagatedBuildInputs = [ simplejson configobj ];

  checkPhase = ''
    
  '';

  meta = with lib; {
    description = "Python API send interface for Zabbix";
    homepage = src.meta.homepage;
    license = [ licenses.gpl3 ];
    maintainers = [ maintainers.wigust ];
  };
}
