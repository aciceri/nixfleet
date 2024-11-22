{
  writers,
  python3Packages,
  fetchFromGitea,
  ...
}:
let
  pyforgejo = python3Packages.buildPythonPackage rec {
    pname = "pyforgejo";
    version = "1.0.4";

    pyproject = true;
    build-system = [ python3Packages.poetry-core ];

    src = fetchFromGitea {
      domain = "codeberg.org";
      owner = "harabat";
      repo = "pyforgejo";
      rev = "3dba949bea41140a47e4dd422a84a6da9fd394e9";
      hash = "sha256-qVXlfhKrc7yBnRvL/65bLZFW9fDjC+8FNz7yA6iMPp4=";
    };

    pythonRelaxDeps = [
      "httpx"
    ];

    dependencies = with python3Packages; [
      attrs
      httpx
      python-dateutil
    ];

    pythonImportsCheck = [ "pyforgejo" ];
  };
in
writers.writePython3Bin "report-checks" {
  libraries = [ pyforgejo ];
  flakeIgnore = [ "E501" ];
} (builtins.readFile ./forgejo-report-checks.py)
