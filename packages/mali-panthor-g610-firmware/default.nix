# Stolen from https://github.com/qbisi/nixos-rockchip

{
  stdenv,
  fetchurl,
  ...
}:
stdenv.mkDerivation {
  pname = "mali-panthor-g610-firmware";
  version = "arch10_8";

  src = fetchurl {
    url = "https://gitlab.com/firefly-linux/external/libmali/-/raw/firefly/firmware/g610/mali_csffw.bin";
    hash = "sha256-56C0b9Z3wy4IwLiBf9HFY8OsoBPax04XaR83O5cNu6s=";
  };

  dontUnpack = true;

  dontPatch = true;

  dontConfigure = true;

  dontBuild = true;

  installPhase = ''
    install -Dm644 $src $out/lib/firmware/arm/mali/arch10.8/mali_csffw.bin
  '';

  passthru = {
    compressFirmware = false;
  };
}
