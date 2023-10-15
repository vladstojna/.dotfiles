# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
	source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
ZSH_TMUX_CONFIG="$HOME/.config/tmux/tmux.conf"

plugins=(
	git
	zsh-autosuggestions
	zsh-syntax-highlighting
	tmux
)

# On macOS, set homebrew environment early if not set. If tmux is installed
# through homebrew, then the 'tmux' plugin will fail because it will not be in
# PATH
if [ "$(uname)" = "Darwin" ] && ! env | grep -q HOMEBREW; then
	eval "$(/opt/homebrew/bin/brew shellenv)"
fi

source "$ZSH/oh-my-zsh.sh"

check() {
	command -v "$1" >/dev/null
}

warn() {
	echo "Warning:" "$@" >&2
}

_zsh_cli_fg() {
	fg
}
zle -N _zsh_cli_fg
bindkey '^Z' _zsh_cli_fg

# For clangd
export CMAKE_EXPORT_COMPILE_COMMANDS=1

if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
	PATH="$HOME/.local/bin:${PATH}"
fi

# rustup
if [ -f "$HOME/.cargo/env" ]; then
	source "$HOME/.cargo/env"
else
	warn "'$HOME/.cargo/env' not found"
fi

# Set these vars on macOS for tmux-256color support
if [ "$(uname)" = "Darwin" ]; then
	export TERMINFO_DIRS="$TERMINFO_DIRS:$HOME/.local/share/terminfo"
	export XDG_CONFIG_HOME="$HOME/.config"
	unalias tmux
fi

# Conda
if [ -z "$__CONDA_CMD" ]; then
	__CONDA_CMD="$HOME/.miniforge3/bin/conda"
	if check conda; then
		__CONDA_CMD=conda
	elif [ ! -f "$HOME/.miniforge3/bin/conda" ]; then
		warn "$__CONDA_CMD does not exist and 'conda' not in PATH"
		unset __CONDA_CMD
	fi
fi
if [ -n "$__CONDA_CMD" ]; then
	eval "$("$__CONDA_CMD" "shell.$(basename "${SHELL}")" hook)"
	if [ -n "$CONDA_DEFAULT_ENV" ]; then
		conda activate "$CONDA_DEFAULT_ENV"
	fi
fi
unset __CONDA_CMD

if check exa; then
	alias ls='exa -al --color=always --group-directories-first'
	alias la='exa -a --color=always --group-directories-first'
	alias ll='exa -l --color=always --group-directories-first'
	alias lt='exa -aT --color=always --group-directories-first'
	alias l.='exa -a | egrep "^\."'
else
	warn "'exa' not found"
fi

if check nvim; then
	alias vim=nvim
	if [[ -n $SSH_CONNECTION ]]; then
		export EDITOR='nvim'
	else
		export EDITOR='nvim'
	fi
else
	warn "'nvim' not found"
fi

if check bat; then
	export BAT_PAGER='less -i'
	export MANPAGER="sh -c 'col -bx | bat -l man -p'"
	alias cat='bat --paging=never'
	alias less='bat --paging=always'
else
	warn "'bat' not found"
fi

unset check
unset warn

# Custom, host-specific settings
if [ -f "${XDG_CONFIG_HOME:-$HOME/.config}/zsh/custom.sh" ]; then
	source "${XDG_CONFIG_HOME:-$HOME/.config}/zsh/custom.sh"
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
