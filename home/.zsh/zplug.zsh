export ZPLUG_LOADFILE="$ZDOTDIR/packages.zsh"

source ~/.zplug/init.zsh

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
  # printf "Install zsh plugin? [y/N]: "
  # if read -q; then
  echo; zplug install
  # fi
fi

# Then, source plugins and add commands to $PATH
zplug load
# ZPLUG_USE_CACHE=false zplug load
