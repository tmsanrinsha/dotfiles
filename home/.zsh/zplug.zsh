if [ ! -d ~/.zplug ]; then
    # printf "Install zplug? [y/N]: "
    # if read -q; then
        # echo;
        git clone https://github.com/b4b4r07/zplug ~/.zplug
        source ~/.zplug/zplug
        # manage zlug by itself
        zplug update --self
    # fi
fi

if [ -f ~/.zplug/zplug ]; then
    source ~/.zplug/zplug

    # Make sure you use double quotes
    zplug "b4b4r07/zplug"
    zplug "zsh-users/zsh-completions"
    zplug "Valodim/zsh-curl-completion"
    zplug "srijanshetty/zsh-pandoc-completion"
    zplug "tmsanrinsha/zsh-composer-completion"
    zplug "Tarrasch/zsh-bd"
    zplug "Dannyzen/cf-zsh-autocomplete-plugin"

    # Install plugins if there are plugins that have not been installed
    if ! zplug check --verbose; then
        # printf "Install zsh plugin? [y/N]: "
        # if read -q; then
            echo; zplug install
        # fi
    fi

    # Then, source plugins and add commands to $PATH
    zplug load --verbose
fi
