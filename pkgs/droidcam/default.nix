{ stdenv, fetchzip, pkgconfig, ffmpeg, gtk3-x11, libjpeg, libusbmuxd, alsaLib, speex }:

stdenv.mkDerivation rec {
  pname = "droidcam";
  version = "0";

  src = fetchzip {
    url = "https://github.com/dev47apps/droidcam/archive/refs/tags/v1.7.2.zip";
    sha256 = "1iskvs5p71gkiinj78kkl9ygl5il9rdbzm0h85hwyzm2xwkcybrp";
  };

  sourceRoot = "source";

  buildInputs = [ pkgconfig ];
  nativeBuildInputs = [ ffmpeg gtk3-x11 libusbmuxd alsaLib libjpeg speex ];

  postPatch = ''
    	cat Makefile
    	ls ${libusbmuxd.out}/lib
      sed -i -e 's:-lusbmuxd:-I ${libusbmuxd.out} ${libusbmuxd.out}/lib/libusbmuxd-2.0.so:' Makefile
      sed -i -e 's:/opt/libjpeg-turbo:${libjpeg.out}:' Makefile
      sed -i -e 's:$(JPEG_DIR)/lib`getconf LONG_BIT`:${libjpeg.out}/lib:' Makefile
      sed -i -e 's:libturbojpeg.a:libturbojpeg.so:' Makefile
    	cat Makefile
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp droidcam droidcam-cli $out/bin/
  '';

  meta = with stdenv.lib; {
    description = "DroidCam Linux client";
    homepage = https://github.com/aramg/droidcam;
  };
}
