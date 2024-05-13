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
	# Save old value of CONDA_DEFAULT_ENV, it is overwritten with the hook cmd
	__CONDA_DEFAULT_ENV="${CONDA_DEFAULT_ENV:-}"
	eval "$("$__CONDA_CMD" "shell.$(basename "${SHELL}")" hook)"
	if [ -n "$__CONDA_DEFAULT_ENV" ]; then
		conda activate "$__CONDA_DEFAULT_ENV"
	fi
	unset __CONDA_DEFAULT_ENV
fi
unset __CONDA_CMD
