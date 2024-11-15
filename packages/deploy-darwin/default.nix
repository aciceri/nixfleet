{
  writeShellApplication,
  ...
}:
writeShellApplication {
  name = "deploy-darwin";
  text = builtins.readFile ./deploy-darwin.sh;
  runtimeInputs = [ ];
}
