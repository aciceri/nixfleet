# Stolen from https://github.com/nyanmisaka/ffmpeg-rockchip

{
  ffmpeg-full,
  fetchFromGitHub,
  lib,
  fetchpatch2,
  gmp,
  amf-headers,
  libiec61883,
  libavc1394,
  meson,
  ninja,
  stdenv,
  fetchurl,
  cmake,
  ...
}:

let
  ffmpeg-rockchip-version = "7.1";

  rga_commit = "d7a0a485ed6c201f882c20b3a8881e801f131385";
  librga-multi = stdenv.mkDerivation {
    pname = "librga-multi";
    version = "1.10.0";

    src = fetchurl {
      url = "https://github.com/JeffyCN/mirrors/archive/${rga_commit}.tar.gz";
      hash = "sha256-WjNxVfLVW8axEvNmIJ0+OCeboG4LiGWwJy6fW5Mkm5Y=";
    };

    # In Nixpkgs, meson comes with a setup hook that overrides the configure, check, and install phases.
    # https://nixos.org/manual/nixpkgs/stable/#meson
    nativeBuildInputs = [
      meson
      ninja
    ];

    patches = [
      (fetchpatch2 {
        name = "normalrga-cpp-add-10b-compact-endian-mode.patch";
        url = "https://raw.githubusercontent.com/7Ji-PKGBUILDs/librga-multi/615fb730b7656ad4a0cb169bfa9a52336820f99f/normalrga-cpp-add-10b-compact-endian-mode.patch";
        hash = "sha256-JvKZCBjWtkEsfx1Xsnysw9PjC3/60f1ni10tmR8fTHQ=";
      })
    ];

    meta = with lib; {
      description = "Rockchip RGA User-Space Library";
      license = licenses.asl20;
    };
  };

  mpp = stdenv.mkDerivation {
    pname = "mpp";
    version = "1.0.8";

    src = fetchFromGitHub {
      owner = "rockchip-linux";
      repo = "mpp";
      rev = "1.0.8";
      hash = "sha256-y1vWGz7VjwL02klPQWwoIh5ExpvS/vsDUHcMtMznVcI=";
    };

    nativeBuildInputs = [ cmake ];

    configurePhase = ''
      cmake -B build -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$out
    '';

    buildPhase = ''
      cmake --build build
    '';

    installPhase = ''
      cmake --install build
    '';

    meta = with lib; {
      description = "Media Process Platform (MPP)";
      homepage = "https://github.com/rockchip-linux/mpp";
      license = licenses.asl20;
    };
  };
in

(ffmpeg-full.override {
  version = ffmpeg-rockchip-version; # Important! This sets the ABI.
  source = fetchFromGitHub {
    owner = "nyanmisaka";
    repo = "ffmpeg-rockchip";
    rev = "f5c7e0d63b52b4526b4251e2fcb2071f73367ed6";
    hash = "sha256-JM/YCvXS49jYz4oF0Ux/aGzrRzKHrD8N/Xm99gXLcqg=";
  };
  withVulkan = false;
}).overrideAttrs
  (old: {
    pname = "ffmpeg-rockchip";

    patches = [ ];
    # patches = old.patches ++ [
    # (fetchpatch2
    #   {
    #     name = "add-av_stream_get_first_dts-for-chromium";
    #     url = "https://raw.githubusercontent.com/7Ji-PKGBUILDs/ffmpeg-mpp-git/b32080c1992313df0e543440c6d70d351120fa36/add-av_stream_get_first_dts-for-chromium.patch";
    #     hash = "sha256-DbH6ieJwDwTjKOdQ04xvRcSLeeLP2Z2qEmqeo8HsPr4=";
    #   }
    # )
    # (fetchpatch2
    #   {
    #     name = "flvdec-handle-unknown";
    #     url = "https://raw.githubusercontent.com/obsproject/obs-deps/faa110d336922831b5cdc261a9559e3a2dd5db3c/deps.ffmpeg/patches/FFmpeg/0001-flvdec-handle-unknown.patch";
    #     hash = "sha256-WlGF9Uy89GcnY8zmh9G23bZiVJtpY32oJiec5Hl/V+8=";
    #   }
    # )
    # (fetchpatch2
    #   {
    #     name = "libaomenc-presets";
    #     url = "https://raw.githubusercontent.com/obsproject/obs-deps/faa110d336922831b5cdc261a9559e3a2dd5db3c/deps.ffmpeg/patches/FFmpeg/0002-libaomenc-presets.patch";
    #     hash = "sha256-1fFBDvsx/jHo6QXsPxDMt4Qd1VlMs1kcOyBedyMv0YM=";
    #   }
    # )
    # ];

    configureFlags = old.configureFlags ++ [
      "--extra-version=rockchip"
      "--enable-gpl"
      "--enable-version3"
      "--enable-libdrm"
      "--enable-rkmpp"
      "--enable-rkrga"
    ];

    doCheck = false; # TODO remove (used to get faster builds)

    buildInputs = old.buildInputs ++ [
      gmp
      amf-headers
      libiec61883
      libavc1394
      mpp
      librga-multi
    ];

    meta = with lib; {
      homepage = "https://github.com/nyanmisaka/ffmpeg-rockchip";
      license = licenses.gpl3;
    };
  })
