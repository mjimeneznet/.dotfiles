# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block, everything else may go below.
#if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
#fi

#------------------------------
# TMUX
#------------------------------

## TODO
#if [[ -z "$TMUX" ]]; then
#    tmux attach -t TMUX || tmux new -s TMUX
#fi

#------------------------------
# History
#------------------------------
HISTSIZE=20000
SAVEHIST=20000
HIST_STAMPS="dd.mm.yyyy"

#------------------------------
# Options
#------------------------------
unsetopt AUTO_NAME_DIRS
unsetopt HIST_VERIFY 
setopt auto_cd
setopt extended_glob
setopt nomatch
setopt notify
setopt auto_menu
setopt complete_in_word
setopt complete_aliases
unsetopt beep

### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
#
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

### End of Zinit's installer chunk

#------------------------------
# Plugins
#------------------------------
zinit light zsh-users/zsh-completions

zinit light zsh-users/zsh-history-substring-search

zinit light zsh-users/zsh-autosuggestions

zplugin ice atinit"zpcompinit; zpcdreplay"
zinit load zdharma/fast-syntax-highlighting

zinit ice depth=1; zinit light romkatv/powerlevel10k

#zinit light junegunn/fzf # from:github, as:plugin, use:"shell/*.zsh"

zinit snippet OMZ::lib/completion.zsh

zinit snippet OMZ::lib/history.zsh

zinit snippet OMZ::lib/key-bindings.zsh

zinit ice as"program" cp"httpstat.sh -> httpstat" pick"httpstat"

zinit ice as"program" cp"emojify -> emofijy" pick"emojify"

zinit light b4b4r07/httpstat

zinit light b4b4r07/emoji-cli

zinit light mrowa44/emojify

#zinit light MichaelAquilina/zsh-auto-notify

zinit light junegunn/fzf

zinit light lincheney/fzf-tab-completion

zinit light reegnz/jq-zsh-plugin 

zinit light chitoku-k/fzf-zsh-completions

zinit light olets/zsh-abbr

#------------------------------
# Plugins
#------------------------------
#source ~/.zplug/init.zsh
#zplug "zplug/zplug", hook-build:"zplug --self-manage"
#zplug "zsh-users/zsh-completions"
#zplug "zsh-users/zsh-history-substring-search"
#zplug "zsh-users/zsh-autosuggestions"
#zplug "zdharma/fast-syntax-highlighting", defer:2
#zplug "romkatv/powerlevel10k", as:theme, depth:1
#zplug "junegunn/fzf", from:github, as:plugin, use:"shell/*.zsh"
#zplug "lib/completion", from:oh-my-zsh
#zplug "lib/history", from:oh-my-zsh
#zplug "lib/key-bindings", from:oh-my-zsh
#zplug "b4b4r07/httpstat", as:command, use:'(*).sh', rename-to:'$1'
#zplug "stedolan/jq", from:gh-r, as:command, rename-to:jq
#zplug "b4b4r07/emoji-cli", on:"stedolan/jq"
#zplug "mrowa44/emojify", from:github, as:command
#zplug "MichaelAquilina/zsh-auto-notify"

#if ! zplug check --verbose; then
#    printf "Install? [y/N]: "
#    if read -q; then
#        echo; zplug install
#    fi
#fi

# Then, source plugins and add commands to $PATH
#zplug load 

eval "$(fasd --init auto)"
#------------------------------
# Completion & Bindings
#------------------------------
[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh
source <(/home/m.jimenez/.asdf/shims/kubectl completion zsh)
[[ -f ~/.docker-compose.zsh ]] && source ~/.docker-compose.zsh
fpath=(~/.asdf/completions $fpath)
command -v flux >/dev/null && . <(flux completion zsh)

autoload -Uz compinit && compinit

zinit cdreplay -q
zstyle ':completion:*' menu select
zstyle ':completion:*' rehash true
zstyle ':completion:*' fzf-search-display true
zstyle ':completion::complete:*' gain-privileges 1

#------------------------------
# Aliases
#------------------------------
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias ls='exa -la --git'
alias superpacman"=pacman -Slq | fzf -m --preview 'cat <(pacman -Si {1}) <(pacman -Fl {1} | awk \"{print \$2}\")' | xargs -r sudo pacman -S"
alias airserver="gst-launch-1.0 airplaysrc ! queue ! h264parse ! avdec_h264 max-threads=1 ! xvimagesink"
alias k="kubectl"
alias d="docker"
alias g="git"
alias m="KUBECONFIG=k3s-kubeconfig kubectl"

#------------------------------
# Exports
#------------------------------
#export MANPAGER="zsh -c 'col -bx | bat -l man -p'"
export PAGER="less -RF"
export BAT_PAGER="less -RF"
export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow -g "!{.git,node_modules}/*" 2> /dev/null'
export FZF_CTRL_T_OPTS="--select-1 --exit-0"


#------------------------------
# Functions
#------------------------------
# Change dir and run a ls
chpwd() {
	exa -la --git
}

dry() {
	docker run --rm -it -v /var/run/docker.sock:/var/run/docker.sock -e DOCKER_HOST=$DOCKER_HOST moncho/dry
}

# Uncompress everything
ex() {
    if [[ -f $1 ]]; then
        case $1 in
          *.tar.bz2) tar xvjf $1;;
          *.tar.gz) tar xvzf $1;;
          *.tar.xz) tar xvJf $1;;
          *.tar.lzma) tar --lzma xvf $1;;
          *.bz2) bunzip $1;;
          *.rar) unrar e $1;;
          *.gz) gunzip $1;;
          *.tar) tar xvf $1;;
          *.tbz2) tar xvjf $1;;
          *.tgz) tar xvzf $1;;
          *.zip) unzip $1;;
          *.Z) uncompress $1;;
          *.7z) 7z x $1;;
          *.dmg) hdiutul mount $1;; # mount OS X disk images
          *) echo "'$1' cannot be extracted via >ex<";;
    esac
    else
        echo "'$1' is not a valid file"
    fi
}

function copycat() {
    cat $1 | xclip -selection clipboard $OUTPUT
} 

# Bitwarden helper
unlock_bw() {
  if [[ -z $BW_SESSION ]]; then
    >&2 echo 'bw locked - unlocking into a new session'
    export BW_SESSION="$(bw unlock --raw)"
  fi
}

export PATH=~/.local/bin:/home/m.jimenez/code/stuart/stuartkube/bin/linux-amd64:$PATH
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# ASDF
[[ ! -f ~/.asdf/asdf.sh ]] || source ~/.asdf/asdf.sh

# Stuart related config
[[ ! -f ~/.stuart.zsh ]] || source ~/.stuart.zsh

# Tilix VTE
if [ $TILIX_ID ] || [ $VTE_VERSION ]; then
	source /etc/profile.d/vte.sh
fi


eval "$(atuin init zsh --disable-up-arrow)" 

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
