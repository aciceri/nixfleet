{
  writers,
  python3Packages,
  ...
}:
writers.writePython3Bin "garmin-collector" {
  libraries = with python3Packages; [
    prometheus-client
    garminconnect
  ];
  flakeIgnore = [ "E501" ];
} (builtins.readFile ./garmin-collector.py)
