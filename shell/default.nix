{ self, inputs, ... }:
{
  exportedModules = with inputs; [
    bud.devshellModules.bud
  ];
  modules = [
    ./devos.nix
  ];
}

