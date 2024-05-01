{
  pkgs,
  dream2nix,
  projectRoot,
  packagePath,
  fetchFromGitHub,
  ...
}: let
  src = fetchFromGitHub {
    owner = "llm-workflow-engine";
    repo = "llm-workflow-engine";
    rev = "v0.18.10";
    hash = "sha256-q9tCPQvGtufSL+E0h5gB0pA1CaKB9nUL1Hf5cmImZz8";
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
    version = "0.18.10";

    paths = {
      inherit projectRoot;
      package = packagePath;
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
      pypiSnapshotDate = "2024-04-25";
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
