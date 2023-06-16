{
  imports = [../email];
  config = {
    accounts.email.accounts = {
      autistici.aerc = {
        enable = true;
      };
      mlabs.aerc = {
        enable = false;
      };
    };
    programs.aerc = {
      enable = true;
      extraBinds = builtins.readFile ./binds.conf;
      extraConfig.general.unsafe-accounts-conf = true;
    };
  };
}
