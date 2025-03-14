host=${1-picard}

nixos-rebuild switch \
  --flake ".#${host}" \
  --target-host "root@${host}.wg.aciceri.dev" \
  --build-host "root@${host}.wg.aciceri.dev" \
  --option warn-dirty false \
  --fast \
  "${@:2}"
