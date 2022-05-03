{ stdenv, fetchzip, kernel }:

# if "Built-in-audio" (virtual device) is not shown in pavucontrol try the following
# pacmd load-module module-alsa-source device=hw:Loopback,1,0

stdenv.mkDerivation rec {
  pname = "v4l2loopback-dc";
  version = "0";

  src = fetchzip {
    url = "https://github.com/dev47apps/droidcam/archive/refs/tags/v1.7.2.zip";
    sha256 = "1iskvs5p71gkiinj78kkl9ygl5il9rdbzm0h85hwyzm2xwkcybrp";
  };

  sourceRoot = "source/v4l2loopback";

  KVER = "${kernel.modDirVersion}";
  KBUILD_DIR = "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build";

  nativeBuildInputs = kernel.moduleBuildDependencies;

  postPatch = ''
    sed -i -e 's:/lib/modules/$(KERNELRELEASE)/build:${KBUILD_DIR}:g' Makefile
  '';

  installPhase = ''
    mkdir -p $out/lib/modules/${KVER}/kernels/media/video
    cp v4l2loopback-dc.ko $out/lib/modules/${KVER}/kernels/media/video/
  '';

  meta = with stdenv.lib; {
    description = "DroidCam kernel module v4l2loopback-dc";
    homepage = https://github.com/aramg/droidcam;
  };
}
