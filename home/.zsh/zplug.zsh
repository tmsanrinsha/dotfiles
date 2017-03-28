export ZPLUG_HOME="$HOME/.zplug"

if [ ! -d ~/.zplug ]; then
  git clone https://github.com/zplug/zplug $ZPLUG_HOME
fi

if [ -f ~/.zplug/init.zsh ]; then
    source ~/.zplug/init.zsh

    # Make sure you use double quotes
    zplug 'zplug/zplug', hook-build:'zplug --self-manage'

    # prompt
    # zplug "olivierverdier/zsh-git-prompt", use:"*.sh"

    # completion
    zplug "zsh-users/zsh-completions"
    zplug "Valodim/zsh-curl-completion"
    zplug "srijanshetty/zsh-pandoc-completion"
    zplug "tmsanrinsha/zsh-composer-completion"
    zplug "Dannyzen/cf-zsh-autocomplete-plugin"

    zplug "Tarrasch/zsh-bd"

    # Install plugins if there are plugins that have not been installed
    if ! zplug check --verbose; then
        # printf "Install zsh plugin? [y/N]: "
        # if read -q; then
            echo; zplug install
        # fi
    fi

    # Then, source plugins and add commands to $PATH
    zplug load
fi
