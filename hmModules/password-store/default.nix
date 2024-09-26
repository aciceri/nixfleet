{
  pkgs,
  username,
  ...
}:
let
  fzfpass = pkgs.writeShellApplication {
    name = "fzfpass";
    text = ''
      find "$PASSWORD_STORE_DIR" -name "*.gpg" | sed "s|$PASSWORD_STORE_DIR/||; s|\.gpg||" | fzf --border --info=inline | xargs pass "$@"
    '';
  };
in
{
  programs.password-store = {
    enable = true;
    settings = {
      PASSWORD_STORE_DIR = "/home/${username}/.password-store";
    };
    package = pkgs.pass.withExtensions (e: [ e.pass-otp ]);
  };
  home.packages = [ fzfpass ];
}
