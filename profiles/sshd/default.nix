{
  services.openssh = {
    enable = true;
    permitRootLogin = "yes";
    forwardX11 = true;
  };

  programs.ssh.setXAuthLocation = true;
}
