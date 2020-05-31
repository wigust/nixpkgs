{ lib, buildPythonApplication, fetchPypi, pyyaml, xmltodict, jq, argcomplete }:

buildPythonApplication rec {
  pname = "yq";
  version = "2.10.1";

  propagatedBuildInputs = [ pyyaml xmltodict jq argcomplete ];

  # ValueError: underlying buffer has been detached
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1h6nnkp53mm4spwy8nyxwvh9j6p4lxvf20j4bgjskhnhaw3jl9gn";
  };

  meta = with lib; {
    description = "Command-line YAML processor - jq wrapper for YAML documents.";
    homepage = "https://github.com/kislyuk/yq";
    license = [ licenses.asl20 ];
    maintainers = [ maintainers.womfoo ];
  };
}
