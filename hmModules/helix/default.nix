{
  programs.helix = {
    enable = true;
    defaultEditor = true;
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
        # inline-diagnostic = {
        #   cursor-line = "hint";
        #   other-lines = "error";
        # };
      };
    };
    languages = {
      language = [
        {
          name = "nix";
          language-servers = ["nixd"];
        }
        {
          name = "markdown";
          language-servers = ["zk"];
        }
        {
          name = "typescript";
          language-servers = ["vtsls"];
        }
      ];
      language-server = {
        nixd.command = "nixd";
        vtsls = {
          command = "vtsls";
          args = ["--stdio"];
        };
        zk = {
          command = "zk";
          args = ["lsp"];
        };
      };
    };
  };
}
