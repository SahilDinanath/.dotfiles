#!/usr/bin/env bash
set -e
pushd ~/.dotfiles/
alejandra . &>/dev/null
git diff -U0 *.nix
echo "NixOS Rebuilding..."
sudo nixos-rebuild switch --flake .#default
gen=$(nixos-rebuild list-generations | grep current)
git commit -am "$gen"
popd
