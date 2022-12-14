let
  dKennedy = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMy9432fJo4IrAQyM6QOdt299LdIAGVLk3CoRh9CKGO0";
  terminator = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE10DQVNfUdc9tVRIFJSxiSaUkFRvN9mgsAia5rpJtrB";

  systems = [ dKennedy terminator ];

  ruwey = "age1yubikey1qgdpghtn06jsv34cplgee633t6d32q55y7rwjfjd28y08ulcvngjze3suaj";
in
{
  "networks.age".publicKeys = [ ruwey ] ++ systems;
  "ruwey/email.age".publicKeys = [ ruwey ] ++ systems;
  "ruwey/spotifyd.age".publicKeys = [ ruwey ] ++ systems;
}


