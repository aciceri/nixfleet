{
  nixos-rebuild,
  writeShellApplication,
  ...
}:
writeShellApplication {
  name = "deploy";
  text = builtins.readFile ./deploy.sh;
  runtimeInputs = [ nixos-rebuild ];
}
