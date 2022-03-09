# Nix CI Demo

This repository contains a number of GitHub Action workflows that demonstrates
how to achieve performant Nix CI builds.

## CI Workflows

* [nixos-configurations/flake.nix](nixos-configurations/flake.nix) contains a
  couple of NixOS configuration builds. The NixOS configurations comes from
  https://github.com/gvolpe/nix-config, and there is a highly recommended
  [blog post](https://gvolpe.com/blog/nixos-binary-cache-ci/) by Gabriel Volpe
  that describes in detail how his NixOS configurations are built on
  GitHub Actions.

  In this repository, we have two workflows that builds Gabriel's NixOS
  configurations.

  The [nixos-cfgs-cachix.yaml](.github/workflows/nixos-cfgs-cachix.yaml)
  workflow uses [Cachix](https://www.cachix.org/) to speed up the building by
  caching build results. Gabriel also uses a Cachix-based build process in his
  blog post. We have simplified the building somewhat in our workflow to make it
  clearer, but the idea is the same.

  The [nix-ci-nixbuild.yaml](.github/workflows/nix-ci-nixbuild.yaml) instead
  uses [nixbuild.net](https://nixbuild.net/) to perform the same builds.


* [nix-ci/flake.nix](nix-ci/flake.nix)
