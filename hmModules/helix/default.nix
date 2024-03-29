{
  programs.helix = {
    enable = true;
    settings = {
      theme = "dracula";
      editor = {
        indent-guides.render = true;
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
        true-color = true; # to make colors coherent when in ssh
      };
    };
  };
}
