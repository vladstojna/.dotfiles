#!/bin/sh

readonly config_path="${XDG_CONFIG_HOME:-"$HOME/.config"}"
readonly data_path="${XDG_DATA_HOME:-"$HOME/.local/share"}"

mkdir -vp "$config_path"
mkdir -vp "$data_path"
cp -vr "$(dirname "$1")/.config/"* "$config_path"
cp -vr "$(dirname "$1")/.local/share/"* "$data_path"
cp -v .zshrc .zshrc.aliases "$HOME"
