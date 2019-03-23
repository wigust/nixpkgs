{ stdenv, buildPythonPackage, fetchPypi, lib, requests, python3Packages }:

buildPythonPackage rec {
  pname = "pyzabbix";
  version = "0.7.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0mvm8giv9876dps21zvz3din2qkg09nl0g9q582hglp9vxy8rki3";
  };

  propagatedBuildInputs = [ requests ];

  meta = with lib; {
    description = "Python API interface for Zabbix";
    homepage = src.meta.homepage;
    license = [ licenses.gpl3 ];
    maintainers = [ maintainers.wigust ];
  };
}
