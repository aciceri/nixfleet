{
  programs.helix = {
    enable = true;
    settings = {
      theme = "catppuccin_mocha";
      editor = {
        indent-guides.render = true;
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
        true-color = true; # to make colors coherent when in ssh
      };
    };
    languages = {
      language = [
        {
          name = "nix";
          language-servers = ["nixd"];
        }
      ];
      language-servers = [
        {
          name = "nixd";
          command = "nixd";
        }
      ];
    };
  };
}
