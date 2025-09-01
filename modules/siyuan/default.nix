{
  virtualisation.oci-containers.containers.siyuan = {
    image = "b3log/siyuan:v3.3.0";
    environment = {
      TZ = "Europe/Rome";
      SIYUAN_ACCESS_AUTH_CODE_BYPASS = "true";
    };
    environmentFiles = [
      # config.age.secrets.siyuan-server-env.path
    ];
    volumes = [
      "/mnt/hd/siyuan:/siyuan/workspace:rw"
      # "${./siyuan-server-entry.sh}:/siyuan/entrypoint.sh:ro"
    ];
    ports = [
      "127.0.0.1:6806:6806/tcp"
    ];
    # entrypoint = "/siyuan/entrypoint.sh";
    # cmd = [
    #   "--workspace=/siyuan/workspace/"
    # ];
    # log-driver = "journald";
    # extraOptions = [
    #   "--device=/dev/dri:/dev/dri:rwm"
    #   "--network-alias=${name}"
    #   "--network=oci_net"
    # ];
  };

  services.nginx.virtualHosts."siyuan.sisko.wg.aciceri.dev" = {
    forceSSL = true;
    useACMEHost = "aciceri.dev";
    locations."/" = {
      proxyPass = "http://localhost:6806";
      proxyWebsockets = true;
    };
    extraConfig = ''
      client_max_body_size 50000M;
      proxy_redirect off;
      proxy_set_header Host $host:$server_port;
      proxy_set_header X-Real-IP $remote_addr;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header X-Forwarded-Host $server_name;
      proxy_set_header X-Forwarded-Proto $scheme;
    '';
    serverAliases = [ "siyuan.sisko.zt.aciceri.dev" ];
  };
}
