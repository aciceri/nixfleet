{ pkgs }:

pkgs.cura.overrideAttrs (old: {
  buildInputs = old.buildInputs ++ [ pkgs.jq ];
  postInstall = old.postInstall or "" + ''
    definitions="$out/share/cura/resources/definitions"
    ce3="$definitions/creality_ender3.def.json"
    cat <<< "$(jq '.overrides.machine_disallowed_areas.default_value = []' $ce3)" > $ce3
  '';
})
