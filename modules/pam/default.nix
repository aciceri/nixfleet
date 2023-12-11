{
  security.pam.services.swaylock.text = ''
    auth            include         login
    auth            sufficient      pam_unix.so try_first_pass likeauth nullok
  '';
}
