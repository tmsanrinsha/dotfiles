# $ZPLUG_LOADFILEがないと遅くなるので、使う
# https://github.com/zplug/zplug/issues/368#issuecomment-282566102
export ZPLUG_LOADFILE="$ZDOTDIR/packages.zsh"

source ~/.zplug/init.zsh

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
  echo; zplug install
fi

# Then, source plugins and add commands to $PATH
zplug load
# ZPLUG_USE_CACHE=false zplug load
