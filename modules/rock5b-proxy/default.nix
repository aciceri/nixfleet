{config, ...}: {
  imports = [../nginx-base];
  services.nginx.virtualHosts = {
    localhost.listen = [{addr = "127.0.0.1";}];
    "home.aciceri.dev" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://localhost:${builtins.toString config.services.home-assistant.config.http.server_port}";
        proxyWebsockets = true;
      };
      extraConfig = ''
        proxy_set_header    Upgrade     $http_upgrade;
        proxy_set_header    Connection  $connection_upgrade;
      '';
    };
    "torrent.aciceri.dev" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://localhost:${builtins.toString config.services.transmission.settings.rpc-port}";
      };
    };
    "search.aciceri.dev" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://localhost:8888";
      };
    };
    "invidious.aciceri.dev" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://localhost:${builtins.toString config.services.invidious.port}";
      };
    };
    "photos.aciceri.dev" = {
      extraConfig = ''
        client_max_body_size 50000M;
      '';
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://localhost:2283";
        proxyWebsockets = true;
      };
    };

    # "jellyfin.aciceri.dev" = {
    #   forceSSL = true;
    #   enableACME = true;
    #   locations."/" = {
    #     proxyPass = "http://localhost:8096";
    #   };
    # };
    # "sevenofnix.aciceri.dev" = {
    #   forceSSL = true;
    #   enableACME = true;
    #   locations."/" = {
    #     proxyPass = "http://10.1.1.2:${builtins.toString config.services.buildbot-master.port}";
    #     proxyWebsockets = true;
    #   };
    # };
  };

  # services.oauth2_proxy = {
  #   enable = true;
  #   provider = "oidc";
  #   reverseProxy = true;
  #   # replaces following options with .keyFile

  #   clientID = "shouldThisBePrivate?";
  #   clientSecret = "thisShouldBePrivate";
  #   cookie.secret = "thisShouldBePrivate00000";

  #   email.domains = [ "*" ];
  #   extraConfig = {
  #      # custom-sign-in-logo = "${../../lib/mlabs-logo.svg}";
  #      # scope = "user:email";
  #      # banner = "MLabs Status";
  #      # whitelist-domain = ".status.staging.mlabs.city";
  #     oidc-issuer-url = "http://127.0.0.1:5556/dex";
  #   };
  #   # redirectURL = "https://status.staging.mlabs.city/oauth2/callback";
  #   # keyFile = config.age.secrets.status-oauth2-secrets.path;
  #   # cookie.domain = ".status.staging.mlabs.city";
  #   nginx = {
  #     virtualHosts = [
  # 	"search.aciceri.dev"
  #     ];
  #   };
  # };

  # services.dex = {
  #   enable = true;
  #   settings = {
  #     issuer = "http://127.0.0.1:5556/dex";
  #     storage = {
  # 	type = "postgres";
  # 	config.host = "/var/run/postgresql";
  #     };
  #     web = {
  # 	http = "127.0.0.1:5556";
  #     };
  #     enablePasswordDB = true;
  #     staticClients = [
  # 	{
  # 	  # id = "oidcclient";
  # 	  # name = "client";
  # 	  # redirecturis = [ "https://login.aciceri.dev/callback" ];
  # 	  # secretfile = "/etc/dex/oidcclient"; # the content of `secretfile` will be written into to the config as `secret`.
  # 	}
  #     ];
  #   };
  # };
}
