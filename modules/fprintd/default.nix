{
  imports = [ ../pam ];

  services.fprintd = {
    enable = false; # temporarily disable
  };

  security.polkit.enable = true; # TODO needed?

  # security.pam.services.swaylock.text = ''
  #   auth            include         login
  #   auth            sufficient      pam_unix.so try_first_pass likeauth nullok
  # '';
  #     # auth            sufficient      pam_fprintd.so
}
