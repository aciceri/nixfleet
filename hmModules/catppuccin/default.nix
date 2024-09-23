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

  # TODO move away
  programs.alacritty = {
    enable = true;
    settings = {
      font = {
        normal = {
          family = "Fira Code";
          style = "Regular";
        };
        bold = {
          family = "Fira Code";
          style = "Bold";
        };
        italic = {
          family = "Cascadia Code";
          style = "Italic";
        };
        bold_italic = {
          family = "Fira Code";
          style = "Bold Italic";
        };
        size = 13;
      };
    };
  };
}
