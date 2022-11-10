# TODO: use upstream ytmusic when updated: https://github.com/OzymandiasTheGreat/mopidy-ytmusic/issues/68
{pkgs, ...}: let
  ytmusicapi = pkgs.python310Packages.buildPythonPackage rec {
    pname = "ytmusicapi";
    version = "0.24.0";
    format = "pyproject";
    src = pkgs.python310Packages.fetchPypi {
      inherit pname version;
      hash = "sha256-vbSWgBze3tFLEpHdh3JXij3m5R6iAhTSjrCMaSLZalY=";
    };
    nativeBuildInputs = with pkgs.python310Packages; [
      setuptools
      setuptools-scm
    ];
    propagatedBuildInputs = with pkgs.python310Packages; [
      requests
    ];
  };

  mopidy-ytmusic = pkgs.python310Packages.buildPythonApplication rec {
    pname = "mopidy-ytmusic";
    version = "0.3.5";

    src = pkgs.python3Packages.fetchPypi {
      inherit version;
      pname = "Mopidy-YTMusic";
      sha256 = "0pncyxfqxvznb9y4ksndbny1yf5mxh4089ak0yz86dp2qi5j99iv";
    };

    postPatch = ''
      substituteInPlace setup.py \
        --replace 'ytmusicapi>=0.20.0,<0.21.0' 'ytmusicapi>=0.20.0'
    '';

    propagatedBuildInputs = with pkgs; [
      mopidy
      ytmusicapi
      python310Packages.pytube
    ];

    pythonImportsCheck = ["mopidy_ytmusic"];

    doCheck = false;
  };
in {
  services.mopidy = {
    enable = true;
    extensionPackages = [mopidy-ytmusic] ++ (with pkgs; [mopidy-mpd mopidy-mpris]);
    settings = {
      mpd = {
        enabled = true;
        hostname = "127.0.0.1";
        port = 6600;
        # password = "";
        max_connections = 20;
        connection_timeout = 60;
        # zeroconf = "Mopidy MPD server on $hostname";
      };
      # youtube = {
      #   enabled = true;
      # };
    };
  };
}
