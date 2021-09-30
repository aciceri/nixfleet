{
  services.password-store-sync.enable = true;
  programs.password-store = {
    enable = true;
    settings = {
      PASSWORD_STORE_DIR = "/home/ccr/.password-store";
    };
  };
}
