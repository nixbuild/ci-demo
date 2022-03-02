{

  inputs = {
    nix.url = "github:nixos/nix/master";
  };

  outputs = { self, nix }: {
    inherit (nix) checks;
  };

}
