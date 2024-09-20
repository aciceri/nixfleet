{
  fleetModules,
  ...
}:
{
  imports =
    fleetModules [
      "common"
      "ssh"
      "nix"
    ]
    ++ [
      ./disko.nix
    ];
}
