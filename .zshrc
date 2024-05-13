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
if [ -n "$CONDA_DEFAULT_ENV" ] && [ -e "${XDG_CONFIG_HOME:-$HOME/.config}"/zsh/conda.sh ]; then
	source "${XDG_CONFIG_HOME:-$HOME/.config}"/zsh/conda.sh
fi

alias ls='exa -al --color=always --group-directories-first'
alias la='exa -a --color=always --group-directories-first'
alias ll='exa -l --color=always --group-directories-first'
alias lt='exa -aT --color=always --group-directories-first'
alias l.='exa -a | grep -E "^\."'

alias vim=nvim
export EDITOR='nvim'

export BAT_PAGER='less -i'
export MANPAGER="sh -c 'col -bx | $(command -v bat) -l man -p'"
alias cat='bat --paging=never'
alias less='bat --paging=always'

# Fix bat formatting problems only if groff is installed
if check groff; then
	export MANROFFOPT="-c"
fi

if [ -f "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.zsh ]; then
	source "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.zsh
	export FZF_CTRL_R_OPTS="
	  --preview 'echo {2..} | bat --color=always -pl sh'
	  --preview-window up:3:hidden:wrap
	  --bind 'ctrl-i:toggle-preview'
	  --bind 'ctrl-t:track+clear-query'
	  --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
	  --color header:italic
	  --header 'Press CTRL-Y to copy command into clipboard'"
fi

# Custom, host-specific settings
if [ -e "${XDG_CONFIG_HOME:-$HOME/.config}/zsh/custom.sh" ]; then
	source "${XDG_CONFIG_HOME:-$HOME/.config}/zsh/custom.sh"
fi

check exa || warn "'exa' not found"
check nvim || warn "'nvim' not found"
check bat || warn "'bat' not found"
check fzf || warn "'fzf' not found"

unset check
unset warn

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
