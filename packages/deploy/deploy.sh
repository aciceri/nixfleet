host=${1-mothership}

nixos-rebuild switch \
    --flake ".#${host}" \
    --target-host "root@${host}.fleet" \
    "${@:2}"
