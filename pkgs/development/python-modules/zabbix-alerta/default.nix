{ stdenv, alerta, pyzabbix, buildPythonPackage, fetchFromGitHub, makeWrapper
, six, click, requests, pytz, tabulate, pythonOlder, protobix
}:

buildPythonPackage rec {
  pname = "zabbix-alerta";
  version = "6.5.0";

    src = fetchFromGitHub {
    owner = "alerta";
      repo = "zabbix-alerta";
      rev = "b8f552fcbf195c2032e9fbd6a59dd04f7178d94f";
      sha256 = "1g2qlaln116qkmd66c7h6bl0pd4cv23kp0bvcs4395k5k1pi4id5";
    };

  propagatedBuildInputs = [ alerta pyzabbix protobix ];

  doCheck = false;

  disabled = pythonOlder "3.5";

  meta = with stdenv.lib; {
    homepage = https://alerta.io;
    description = "Alerta Monitoring System command-line interface";
    license = licenses.asl20;
  };
}
