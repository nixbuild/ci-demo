{

  inputs = {
    gvolpe-nix-config.url = "github:gvolpe/nix-config";
    nixpkgs.follows = "gvolpe-nix-config/nixpkgs";
  };

  outputs = { self, nixpkgs, gvolpe-nix-config }: {

    inherit (gvolpe-nix-config) nixosConfigurations;

    packages.x86_64-linux = nixpkgs.lib.mapAttrs
      (_: c: c.config.system.build.toplevel) self.nixosConfigurations;

  };

}
