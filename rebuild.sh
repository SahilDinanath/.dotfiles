#!/usr/bin/env bash
set -e
pushd ~/.dotfiles/
alejandra . &>/dev/null
 git diff -U0 *.nix
 echo "NixOS Rebuilding..."
 sudo nixos-rebuild switch --flake .#default &> nixos-switch.log || (
  cat nixos-switch.log | grep --color error && false)
 gen=$(nixos-rebuild list-generations | grep current)
 git commit -am "$gen"
 git push origin main
popd
