#-----------------------------------------------------------
# auto-generated
#-----------------------------------------------------------

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt autocd beep extendedglob notify
unsetopt nomatch
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/bean/.zshrc'
autoload -Uz compinit
compinit
# End of lines added by compinstall



#-----------------------------------------------------------
# key bindings
#-----------------------------------------------------------

autoload -Uz select-word-style
select-word-style bash

bindkey -e

# Home/End
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line

# alternate Home/End sequences
bindkey '^[OH' beginning-of-line
bindkey '^[OF' end-of-line

# Ctrl + Left/Right
bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word

# alternate Ctrl + Left/Right
bindkey '^[[5D' backward-word
bindkey '^[[5C' forward-word

# Delete
bindkey '^[[3~' delete-char
bindkey '^[3~' delete-char

# Ctrl + Backspace
bindkey '^H' backward-kill-word

source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh



#-----------------------------------------------------------
# change socks:// and socks5:// proxy strings to socks5h://
#-----------------------------------------------------------
if true; then
    for proxy_var in HTTP_PROXY HTTPS_PROXY ALL_PROXY http_proxy https_proxy all_proxy; do
        value="${(P)proxy_var}"

        if [[ "$value" == socks://* ]]; then
            export "$proxy_var"="socks5h://${value#socks://}"
        elif [[ "$value" == socks5://* ]]; then
            export "$proxy_var"="socks5h://${value#socks5://}"
        fi
    done
fi



#-----------------------------------------------------------
# environment variables
#-----------------------------------------------------------

export EDITOR="code --wait"
export FILE_MANAGER=nautilus



#-----------------------------------------------------------
# aliases & functions
#-----------------------------------------------------------

# programs
alias py='python'
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias diff='diff --color=auto'

# find process by name or command line
alias findpc="pgrep -lafi --delimiter $'\n--------------------------------------------------\n'"

# load and edit .zshrc
alias loadrc='source ~/.zshrc'
alias editrc='code ~/.zshrc'

# backup .zshrc
alias backrc='cp ~/.zshrc "/mnt/GG/Projects/0dev/arch-guide"'

# copy to and paste from clipboard (wl-clipboard must be installed)
alias cbc="wl-copy"
alias cbp="wl-paste"

# python virtual environment automation
# usage: pyenv [venv_directory] [-r requirements.txt]
pyenv() {
    # don't nest virtual environments
    if [[ -n "$VIRTUAL_ENV" ]]; then
        echo "already in virtualenv: $VIRTUAL_ENV"
        echo "run 'deactivate' first if you want to switch." >&2
        return 1
    fi

    # parse arguments
    local venv_dir=".venv"
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -*)
                echo "unknown option: $1" >&2
                return 1
                ;;
            *)
                venv_dir="$1"
                shift
                ;;
        esac
    done

    # find a working Python interpreter
    local python_cmd
    for cmd in python3 python; do
        if command -v $cmd &>/dev/null; then
            python_cmd=$cmd
            break
        fi
    done
    if [[ -z $python_cmd ]]; then
        echo "no Python interpreter found (tried python3, python)." >&2
        return 1
    fi

    # activate if it already exists
    if [[ -f "$venv_dir/bin/activate" ]]; then
        source "$venv_dir/bin/activate"
        echo "activated existing virtualenv: $venv_dir"
        return 0
    fi

    # create
    echo "creating virtualenv in $venv_dir using $python_cmd..."
    if $python_cmd -m venv "$venv_dir"; then
        source "$venv_dir/bin/activate"
    else
        echo "failed to create virtual environment." >&2
        return 1
    fi
}

# fonts
alias editfonts='code ~/.config/fontconfig/fonts.conf'
alias reloadfonts='fc-cache -fv'

# generate qr code in the terminal
alias qr="qrencode -t UTF8"

# run sudo in a loop in the background to avoid timeout. useful when installing
# many packages with something like yay which might ask for a password at a
# random time when you're not aware.
alias sudoloop='sudo -v && while true; do sudo -v; sleep 30; done &'

the-pacman() {
    sudo --preserve-env=ALL_PROXY,all_proxy pacman --color auto "$@"
}
the-yay() {
    yay --color auto "$@"
}

# pacman: install
alias pac="the-pacman -S --noconfirm --needed"

# pacman: remove
alias pacr="the-pacman -R"

# pacman: sync databases
alias pacsync="the-pacman -Syy"

# pacman and yay: update everything
pacupp() {
    local reply
    read "reply?update yay packages too (AUR)? (y/N) "

    sudoloop
    the-pacman -Syu --noconfirm || return

    if [[ $reply == [Yy]* ]]; then
        the-yay -Syu --noconfirm || return
    fi

    echo "updated everything"
}

# yay: update everything
alias yayupp='the-yay -Syu --noconfirm'

# yay: install
alias yayy='the-yay -S --noconfirm --needed'

# yay: remove
alias yayr='the-yay -R'

# search package name in both pacman and the AUR
alias pacfind='the-yay -Ss'

# make a backup of packages installed with both pacman and yay
alias backpac='pacman -Qe > ~/installed-packages.txt && pacman -Q > ~/installed-packages-all.txt'

# git
alias gits='git status'
alias gitd='git diff'
alias gita='git add'
alias gitall='git add -A'
function gitdf {
    git diff "*$1*"
}
function gitaf {
    git add "*$1*"
}
alias gitc='git commit -m'
alias gitam='git commit --amend -m'
alias gitp='git push'
alias gitpl='git pull'
alias gitf='git fetch -f'
alias gitl='git log --oneline'
alias gitll='git log'

# run copyparty for sharing a folder to the network (install copyparty first)
copypartyy() {
    local root_dir admin_pw readonly_pw port
    local -a cmd

    printf "root directory for sharing (default: ./): "
    read -r root_dir
    [[ -z "$root_dir" ]] && root_dir="./"

    while true; do
        printf "admin password: "
        read -rs admin_pw
        printf "\n"

        if (( ${#admin_pw} > 3 )); then
            break
        fi

        echo "password must be longer than 3 characters."
    done

    while true; do
        printf "guest password (optional): "
        read -rs readonly_pw
        printf "\n"

        if [[ -z "$readonly_pw" || ${#readonly_pw} -gt 3 ]]; then
            break
        fi

        echo "password must be longer than 3 characters, or left empty."
    done

    printf "server port (default: 55555): "
    read -r port
    [[ -z "$port" ]] && port=55555

    cmd=(
        copyparty
        -p "$port"
        -j 0
        --usernames
        -a "admin:$admin_pw"
    )

    if [[ -n "$readonly_pw" ]]; then
        cmd+=(
            -a "guest:$readonly_pw"
            -v "$root_dir::A,admin:r,guest"
        )
    else
        cmd+=(
            -v "$root_dir::A,admin"
        )
    fi

    echo
    echo "starting copyparty..."
    "${cmd[@]}"
}

# run copyparty and share the current working directory (quick'n'dirty)
copypartyq() {
    local root_dir admin_pw readonly_pw port
    local -a cmd

    root_dir="./"
	admin_pw="welcome"
    readonly_pw="guest"

    printf "server port (default: 55555): "
    read -r port
    [[ -z "$port" ]] && port=55555

    cmd=(
        copyparty
        -p "$port"
        -j 0
        --usernames
        -a "admin:$admin_pw"
    )

    if [[ -n "$readonly_pw" ]]; then
        cmd+=(
            -a "guest:$readonly_pw"
            -v "$root_dir::A,admin:r,guest"
        )
    else
        cmd+=(
            -v "$root_dir::A,admin"
        )
    fi

    echo
    echo "starting copyparty..."
    "${cmd[@]}"
}

# set a SOCKS5 proxy config (share link) for gg. gg lets us proxy an entire
# command. for example: `gg curl https://google.com` will route the network
# traffic of that command through the previously set config or share link.
ggset() {
    if [[ $# -ne 1 ]]; then
        echo "usage: ggset <host:port>"
        return 1
    fi
    gg config -w "node=socks://Og@$1"
}

# start a zsh session with network traffic routed through gg
ggsh() {
    env -u ALL_PROXY -u HTTP_PROXY -u HTTPS_PROXY \
        -u all_proxy -u http_proxy -u https_proxy \
    sudo -EH \
    gg -n "$(gg config node)" \
    sudo -EH -u "$USER" zsh
}

# * NOT RECOMMENDED, USE ggset AND ggsh INSTEAD.
# set a SOCKS5 proxy for ssh, git, pacman, curl(? not sure), etc.
set_socks5() {
    local proxy_addr="$1"
    if [[ -z "$proxy_addr" ]]; then
        echo "usage: set_socks5 host:port"
        return 1
    fi

    alias ssh="ssh -o ProxyCommand=\"ncat --proxy-type socks5 --proxy $proxy_addr %h %p\""
    export GIT_SSH_COMMAND="ssh -o ProxyCommand='ncat --proxy-type socks5 --proxy $proxy_addr %h %p'"
    export ALL_PROXY="socks5h://$proxy_addr"
    export all_proxy="socks5h://$proxy_addr"
    git config --global http.proxy socks5h://$proxy_addr
    git config --global https.proxy socks5h://$proxy_addr

    loadrc
}

# * NOT RECOMMENDED, USE ggset AND ggsh INSTEAD.
# set HTTP proxy
set_http() {
    local proxy_addr="$1"
    if [[ -z "$proxy_addr" ]]; then
        echo "usage: set_http host:port"
        return 1
    fi

    alias ssh="ssh -o ProxyCommand=\"ncat --proxy-type http --proxy $proxy_addr %h %p\""
    export GIT_SSH_COMMAND="ssh -o ProxyCommand='ncat --proxy-type http --proxy $proxy_addr %h %p'"
    export HTTP_PROXY="http://$proxy_addr"
    export http_proxy="http://$proxy_addr"
    export HTTPS_PROXY="http://$proxy_addr"
    export https_proxy="http://$proxy_addr"
    export ALL_PROXY="http://$proxy_addr"
    export all_proxy="http://$proxy_addr"
    git config --global http.proxy http://$proxy_addr
    git config --global https.proxy http://$proxy_addr

    loadrc
}

# unset proxy for ssh, git, pacman, curl(? not sure), etc.
unset_proxy() {
    unalias ssh 2>/dev/null
    unset GIT_SSH_COMMAND
    unset HTTP_PROXY http_proxy HTTPS_PROXY https_proxy ALL_PROXY all_proxy
    git config unset --global http.proxy
    git config unset --global https.proxy
    loadrc
}

# create HTTP proxy that forwards to SOCKS5 proxy
alias forward2socks5="glider -listen http://:7342 -forward socks5h://127.0.0.1:1080 > /dev/null & disown"

# curl a file and print the average download speed
alias curlspeed='curl -o /dev/null -s -w "file size: %{size_download}\nspeed: %{speed_download} bytes/sec\ntotal time: %{time_total} sec\n"'

# create SSH key
sshcreate() {
    mkdir -p ~/.ssh

    local SSH_KEY_EMAIL
    local SSH_KEY_PATH

    read "SSH_KEY_EMAIL?email: "
    read "SSH_KEY_PATH?key path [~/.ssh/id_ed25519]: "

    if [[ -z "$SSH_KEY_PATH" ]]; then
        SSH_KEY_PATH="$HOME/.ssh/id_ed25519"
    fi

    ssh-keygen -t ed25519 -C "$SSH_KEY_EMAIL" -f "$SSH_KEY_PATH"

    printf "\ncreated SSH key %s\npublic key:\n" "$SSH_KEY_PATH"
    cat "$SSH_KEY_PATH.pub"
}

# start SSH agent given SSH key path (defaults to ~/.ssh/id_ed25519)
sshinit() {
    local SSH_KEY_PATH="${1:-$HOME/.ssh/id_ed25519}"

    # check if the key exists.
    if [[ ! -f "$SSH_KEY_PATH" ]]; then
        printf 'error: SSH key does not exist: %s\n' "$SSH_KEY_PATH" >&2
        return 1
    fi

    # warn if permissions are not 600
    local perms
    perms=$(stat -c '%a' "$SSH_KEY_PATH" 2>/dev/null || stat -f '%Lp' "$SSH_KEY_PATH" 2>/dev/null)
    if [[ "$perms" != "600" ]]; then
        printf 'warning: %s has permissions %s (expected 600).\n' "$SSH_KEY_PATH" "$perms" >&2
    fi

    # start ssh-agent unless it's already running
    if [[ -z "$SSH_AUTH_SOCK" ]] || ! ssh-add -l >/dev/null 2>&1; then
        eval "$(ssh-agent -s)"
    fi

    # add the key
    ssh-add "$SSH_KEY_PATH"
}

# zip a directory (by default, the current working directory) while respecting
# .gitignore recursively.
zipignore() {
    local dir="${1:-.}"
    local archive="${2:-archive.zip}"
    local tmp_archive

    # must be inside a git repo
    if ! git -C "$dir" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        echo >&2 "zipignore: '$dir' is not a git repo."
        return 1
    fi

    # create a unique filename
    tmp_archive=$(mktemp /tmp/zipignore_XXXXXX.zip)
    rm -f "$tmp_archive"
    trap 'rm -f "$tmp_archive"' EXIT

    # collect files via git
    (
        cd "$dir" || exit 1
        git ls-files -z --cached --others --exclude-standard |
            tr '\0' '\n' |
            zip "$tmp_archive" -@
    ) || {
        echo >&2 "zipignore: failed to create archive."
        return 1
    }

    # move finished archive into the target directory
    mv "$tmp_archive" "$dir/$archive"
    echo "created archive: $dir/$archive"
}

# zip a directory (by default, the current working directory) with a password
# while respecting .gitignore recursively.
zipignore-pw() {
    local dir="${1:-.}"
    local archive="${2:-archive.zip}"
    local password tmp_archive

    # must be inside a git repo
    if ! git -C "$dir" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        echo >&2 "zipignore: '$dir' is not a git repo."
        return 1
    fi

    # read password securely
    echo -n "password: "
    read -rs password
    echo
    if [[ -z "$password" ]]; then
        echo >&2 "zipignore: password cannot be empty."
        return 1
    fi

    # create a unique filename
    tmp_archive=$(mktemp /tmp/zipignore_XXXXXX.zip)
    rm -f "$tmp_archive"
    trap 'rm -f "$tmp_archive"' EXIT

    # collect files via git
    (
        cd "$dir" || exit 1
        git ls-files -z --cached --others --exclude-standard |
            tr '\0' '\n' |
            zip -P "$password" "$tmp_archive" -@
    ) || {
        echo >&2 "zipignore: failed to create archive."
        return 1
    }

    # move finished archive into the target directory
    mv "$tmp_archive" "$dir/$archive"
    echo "created encrypted archive: $dir/$archive"
}

cleanupp() {
    emulate -L zsh

    local before_kib after_kib freed_kib freed_mib
    before_kib=$(command df --output=avail -k / | tail -n1 | tr -d ' ')

    echo "==> cleaning old pacman cache..."
    if command -v paccache >/dev/null 2>&1; then
        sudo paccache -rvk2
    else
        echo "paccache not found, installing pacman-contrib..."
        sudo pacman -S --needed pacman-contrib
        sudo paccache -rvk2
    fi

    echo
    echo "==> cleaning yay cache..."
    if command -v yay >/dev/null 2>&1; then
        yay -Sc --aur --noconfirm
    else
        echo "yay not found, skipping"
    fi

    echo
    echo "==> vacuuming old journal logs..."
    sudo journalctl --vacuum-time=2weeks

    echo
    echo "==> cleaning unused temporary files..."

    # clean /tmp files not accessed in a day
    sudo find /tmp \
        -type f \
        -atime +1 \
        ! -exec fuser {} \; \
        -delete 2>/dev/null

    # clean user temp files
    find "${TMPDIR:-/tmp}" \
        -type f \
        -atime +1 \
        ! -exec fuser {} \; \
        -delete 2>/dev/null

    echo
    echo "==> cleaning old cache files..."

    find ~/.cache \
        -maxdepth 5 \
        -type f \
        -atime +7 \
        -delete 2>/dev/null

    after_kib=$(command df --output=avail -k / | tail -n1 | tr -d ' ')
    freed_kib=$(( after_kib - before_kib ))
    freed_mib=$(( freed_kib / 1024 ))

    echo
    echo "==> cleanup complete, ~${freed_mib} MiB freed."
}

# get fresh V2Ray configs (share links) and copy to clipboard
alias getv2r="curl -sS https://raw.githubusercontent.com/barry-far/V2ray-Config/refs/heads/main/All_Configs_Sub.txt | cbc"

# this is for a weird bug where sudo randomly stops accepting my password
alias resetfaillock="faillock --user $USER --reset"

alias update-mirrors='sudo reflector --connection-timeout 3 --download-timeout 3 --sort rate --threads 8 -c de,fi,us --ipv4 -f 32 --save /etc/pacman.d/mirrorlist'



#-----------------------------------------------------------
# interactive commands to run in the terminal when it opens
#-----------------------------------------------------------

# if running non-interactively, don't do anything after this point.
[[ $- != *i* ]] && return

# nothing for now, but an example would be `fastfetch --pipe 0`.
