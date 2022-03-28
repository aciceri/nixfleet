{ config, ... }: {
  home-manager.sharedModules = [
    {
      home.sessionVariables = {
        inherit (config.environment.sessionVariables) NIX_PATH;
      };
    }
  ];
}
