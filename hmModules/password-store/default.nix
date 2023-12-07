{
  pkgs,
  username,
  ...
}: {
  programs.password-store = {
    enable = true;
    settings = {
      PASSWORD_STORE_DIR = "/home/${username}/.password-store";
    };
    package = pkgs.pass.withExtensions (e: [e.pass-otp]);
  };
}
