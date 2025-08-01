{ pkgs, ... }:
{
  home.packages = with pkgs; [
    zk
    nixd
    nixfmt
    claude-code
    terraform-ls
    python3Packages.python-lsp-server
    nodePackages.typescript-language-server
  ];

  programs.helix = {
    enable = true;
    settings = {
      editor = {
        indent-guides.render = true;
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
        color-modes = true;
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
          language-servers = [ "nixd" ];
          formatter.command = "nixfmt";
        }
        {
          name = "markdown";
          language-servers = [ "zk" ];
        }
        {
          name = "typescript";
          language-servers = [ "vtsls" ];
        }
      ];
      language-server = {
        nixd.command = "nixd";
        zk = {
          command = "zk";
          args = [ "lsp" ];
        };
      };
    };
  };
}
