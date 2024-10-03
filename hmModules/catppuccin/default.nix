{ lib, ... }:
{
  catppuccin = {
    enable = true;
    flavor = "mocha";
    accent = "sapphire";
  };

  qt = {
    platformTheme.name = lib.mkForce "kvantum";
    style.name = lib.mkForce "kvantum";
  };
}
