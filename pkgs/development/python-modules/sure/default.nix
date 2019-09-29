{ stdenv
, buildPythonPackage
, fetchPypi
, rednose
, six
, mock
, isPyPy
}:

buildPythonPackage rec {
  pname = "sure";
  version = "1.2.3";
  disabled = isPyPy;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1xxdrzjq7cdk92kvfjv6p99vx5csw5kljf0x5m7hjqsvvrvh487n";
  };

  buildInputs = [ rednose ];
  propagatedBuildInputs = [ six mock ];

  meta = with stdenv.lib; {
    description = "Utility belt for automated testing";
    homepage = https://sure.readthedocs.io/en/latest/;
    license = licenses.gpl3Plus;
  };

}
