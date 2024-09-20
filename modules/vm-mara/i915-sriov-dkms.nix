{
  stdenv,
  kernel,
  fetchFromGitHub,
  ...
}:
let
  m = stdenv.mkDerivation rec {
    name = "i915-sriov-dkms";
    version = "4d89a1d5ba8c66308e3276c5297eda838c70cc31";

    src = fetchFromGitHub {
      owner = "strongtz";
      repo = "i915-sriov-dkms";
      rev = "db4e8ccd9bd31fad79361e27afc032487426fe6a";
      hash = "sha256-WCDwy39jpnc2wkM/883gFwChVD7wAP2nCR8Aw+CfDw8=";
    };

    nativeBuildInputs = kernel.moduleBuildDependencies;

    setSourceRoot = ''
      export sourceRoot=$(pwd)/source
    '';

    makeFlags = kernel.makeFlags ++ [
      "-C"
      "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
      "M=$(sourceRoot)"
      "KVER=${kernel.version}"
    ];

    # installPhase = ''
    # install -D i915.ko $out/lib/modules/${kernel.modDirVersion}/kernel/drivers/gpu/drm/i915/i915.ko
    # '';

    installFlags = [ "INSTALL_MOD_PATH=${placeholder "out"}" ];

    installTargets = [ "modules_install" ];

    enableParallelBuilding = true;

    # meta.priority = -10;
  };
in
m
# in runCommand "test" {} ''
#   # mkdir -p $out/lib/modules/6.1.30/kernel/drivers/gpu/drm/i915
#   mkdir -p $out/lib/modules/6.1.30/extra
#   cp ${m}/lib/modules/6.1.30/extra/i915.ko.xz $out/lib/modules/6.1.30/extra/foo.ko.xz
# ''
