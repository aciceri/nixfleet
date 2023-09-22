{pkgs, ...}: {
  home.packages = [pkgs.whatsapp-for-linux];

  systemd.user.services.whatsapp = {
    Install.WantedBy = ["graphical-session.target"];

    Unit = {
      Description = "Whatsapp";
      PartOf = ["graphical-session.target"];
    };

    Service = {
      ExecStart = "${pkgs.whatsapp-for-linux}/bin/whatsapp-for-linux";
      Restart = "on-failure";
      RestartSec = 3;
    };
  };
}
