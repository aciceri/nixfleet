{pkgs, ...}: {
  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    sshKeys = ["CE2FD0D9BECBD8876811714925066CC257413416"];
    extraConfig = let
      pinentryRofi = pkgs.writeShellApplication {
        name = "pinentry-rofi-with-env";
        runtimeInputs = with pkgs; [coreutils rofi];
        text = ''
          "${pkgs.pinentry-rofi}/bin/pinentry-rofi" "$@"
        '';
      };
    in ''
      allow-emacs-pinentry
      allow-loopback-pinentry
      pinentry-program ${pinentryRofi}/bin/pinentry-rofi-with-env
    '';
  };

  programs.gpg = {
    enable = true;
    settings = {};
  };
}
