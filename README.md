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

  The [nixos-cfgs-cachix.yaml](https://github.com/nixbuild/ci-demo/actions/workflows/nixos-cfgs-cachix.yaml)
  workflow uses [Cachix](https://www.cachix.org/) to speed up the building by
  caching build results. Gabriel also uses a Cachix-based build process in his
  blog post. We have simplified the building somewhat in our workflow to make it
  clearer, but the idea is the same.

  The [nixos-cfgs-nixbuild.yaml](https://github.com/nixbuild/ci-demo/actions/workflows/nixos-cfgs-nixbuild.yaml)
  instead uses [nixbuild.net](https://nixbuild.net/) to perform the same builds.
  It uses Nix ability to run builds in a remote Nix store to achieve the
  **fastest possible** Nix CI builds. The support for remote store building in
  nixbuild.net is a beta feature, but it is available to all nixbuild.net users
  with no extra setup needed.

  Remote store building avoids having to download any build inputs and outputs
  to the GitHub Action runner machine, which makes a no-op build of the NixOS
  configurations take around **30 seconds**, compared to **5 minutes** for doing
  the same thing using Cachix.


* [nix-ci/flake.nix](nix-ci/flake.nix)
