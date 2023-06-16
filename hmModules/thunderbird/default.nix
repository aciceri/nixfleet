{
  imports = [../email];
  config = {
    accounts.email.accounts = {
      autistici.thunderbird = {
        enable = true;
        profiles = ["default"];
      };
      mlabs.thunderbird = {
        enable = true;
        profiles = ["default"];
      };
    };
    programs.thunderbird = {
      enable = true;
      profiles = {
        default = {
          isDefault = true;
        };
        # mlabs = {};
      };
    };
  };
}
