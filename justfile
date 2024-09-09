#!/usr/bin/env just --justfile
set shell := ["zsh", "-cu"]
set fallback

default:
  just -u --list

install:
  make build && make install && make enable

rm-update:
  rm -r ~/.local/share/gnome-shell/extension-updates/forge@jmmaranan.com
