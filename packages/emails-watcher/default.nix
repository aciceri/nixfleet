{
  writers,
  python3Packages,
  ...
}:
writers.writePython3Bin "emails-watcher" {
  libraries = with python3Packages; [
    watchdog
    desktop-notifier
  ];
  flakeIgnore = [ ];
} (builtins.readFile ./emails-watcher.py)
