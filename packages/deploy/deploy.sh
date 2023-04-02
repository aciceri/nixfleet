host=${1-mothership}

nixos-rebuild switch \
    --flake ".#${host}" \
    --target-host "root@${host}.fleet" \
    --option warn-dirty false \
    "${@:2}"
