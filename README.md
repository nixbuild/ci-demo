# Nix CI Demo

This repository contains a number of GitHub Action workflows that demonstrates
how to achieve performant Nix CI builds.

We are using GitHub Actions as CI provider here, but everything demonstrated in
this repository is applicable for other providers too (like GitLab, BuildKite,
self hosted etc).


## CI Workflows


### NixOS Configuration Builds

[nixos-configurations/flake.nix](nixos-configurations/flake.nix) contains a
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


### Building Nix

[nix-ci/flake.nix](nix-ci/flake.nix) imports the tests defined in the
[Nix repository](https://github.com/nixpkgs/nix/), which makes it possible for
us to run the same things that Nix runs in its CI (which is also
[using](https://github.com/NixOS/nix/actions/workflows/ci.yml) GitHub
Actions).

We have two workflows for the Nix CI,
[nix-ci-cachix.yaml](https://github.com/nixbuild/ci-demo/actions/workflows/nix-ci-cachix.yaml)
using [Cachix](https://www.cachix.org/), and
[nix-ci-nixbuild.yaml](https://github.com/nixbuild/ci-demo/actions/workflows/nix-ci-nixbuild.yaml)
using [nixbuild.net](https://nixbuild.net), set up just like the NixOS
workflows described above.

For the moment, we run the `x86_64-linux` checks defined in the
[flake.nix](https://github.com/NixOS/nix/blob/master/flake.nix) file of the Nix
repository. These checks builds Nix and its tarballs, and runs tests against the
produced Nix binary. This corresponds to the `tests` jobs in the
[CI](https://github.com/NixOS/nix/actions/workflows/ci.yml) workflow of the
Nix repository.

For no-op builds, both the Cachix and nixbuild.net workflows finish in about
30 seconds. The reason there is not much difference is that the produced Nix
closures are much smaller than in the NixOS case.

When a build of the Nix sources actually is required, the Cachix workflow
takes about **20 minutes**, in line with with the official Nix CI (which is
also using Cachix to speed up builds). The nixbuild.net workflow halves that
time to **10 minutes**. This is because the builders in nixbuild.net are
faster than the GitHub runner machine, and nixbuild.net can run any number of
builds in parallel. Also, no build inputs have to be fetched to the GitHub
runner.
