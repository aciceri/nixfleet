{
  pkgs,
  dream2nix,
  fetchFromGitHub,
  ...
}: let
  src = fetchFromGitHub {
    owner = "llm-workflow-engine";
    repo = "llm-workflow-engine";
    rev = "a6b1e59d350dae210d37cdfd2050a3b79f19ab14";
    hash = "sha256-foG3g63Yx5QtNcBP5aOnkmqOWsj0tX3EOHq3Il5WE+M=";
  };
  module = {
    config,
    lib,
    dream2nix,
    ...
  }: {
    imports = [
      dream2nix.modules.dream2nix.pip
    ];

    name = "llm-workflow-engine";
    version = "0.18.2";

    paths = {
      projectRoot = ./.;
      projectRootFile = "flake.nix";
      package = ./.;
    };

    mkDerivation = {
      src = src;
      propagatedBuildInputs = [
        config.pip.drvs.setuptools.public
      ];
    };

    buildPythonPackage = {
      format = lib.mkForce "pyproject";
      pythonImportsCheck = [
        "lwe"
      ];
      catchConflicts = false;
    };

    pip = {
      pypiSnapshotDate = "2023-09-29";
      requirementsFiles = [
        "${src}/requirements.txt"
      ];
      requirementsList = [
        "setuptools"
      ];
      flattenDependencies = true;
    };
  };
in
  dream2nix.lib.evalModules {
    specialArgs.dream2nix = dream2nix;
    packageSets.nixpkgs = pkgs;
    modules = [module];
  }
