let
  dKennedy = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMy9432fJo4IrAQyM6QOdt299LdIAGVLk3CoRh9CKGO0";
  # add terminator
  systems = [ dKennedy ];

  ruwey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPVG7daV3V43tnci2HbyJaPlRGrR2NEWrWfwxHSP0cd/";
in
{
  "networks.age".publicKeys = [ ruwey ] ++ systems;
  "ruwey/email.age".publicKeys = [ ruwey ] ++ systems;
  "ruwey/spotifyd.age".publicKeys = [ ruwey ] ++ systems;
}


