CLOSURE_DRV=$(nix eval .#darwinConfigurations.archer.config.system.build.toplevel.drvPath --raw)
echo "$CLOSURE_DRV"

nix copy --to ssh://admin@macos-ventura "$CLOSURE_DRV"

# shellcheck disable=SC2029
ssh admin@macos-ventura "nix build $CLOSURE_DRV^out"
ssh admin@macos-ventura "./result/activate-user"
ssh admin@macos-ventura "echo admin | sudo -S ./result/activate"
# ssh admin@macos-ventura "./result/sw/bin/darwin-rebuild activate"
ssh admin@macos-ventura "nix profile install ./result"
