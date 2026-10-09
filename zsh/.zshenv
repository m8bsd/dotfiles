# .zshenv - environment variables for zsh

# DO NOT LOAD /etc/profile which resets stuff here.
# 07dec2011  +leah+
setopt NO_GLOBAL_RCS
fpath=(~/.zfunc $fpath)

# == ENVIRONMENT

export PATH
typeset -U path PATH

TLYEAR=(/opt/texlive/20??(Nn[-1]:t))

# pathadd [-P] [PATHS] [-- APPEND_PATHS] - prepend/append PATHS to path
# 08jan2018  +leah+
# 09jan2018  +leah+
# 11aug2021  +leah+  -P to not follow symlinks, useful for Nix
pathadd() {
  setopt LOCAL_OPTIONS EXTENDED_GLOB
  if [[ $1 == -P ]]; then shift; else set -- ${@//#%(#m)*~--/$MATCH:A}; fi
  path=( ${^${@[1,$@[(i)--]-1]}:|path}(N-/)
         $path
         ${^${@[$@[(i)--]+1,-1]}:|path}(N-/) )
}

[[ -o login ]] && path=()
pathadd -P ~/.nix-profile/bin
pathadd -- /usr/{s,}bin /{s,}bin
pathadd /usr/local/{s,}bin
pathadd -- /usr/games /usr/games/bin
pathadd -P -- /nix/var/nix/profiles/default/bin /run/current-system/sw/bin
pathadd -P /run/wrappers/bin
pathadd /opt/texlive/$TLYEAR/bin/$MACHTYPE-linux
pathadd ~/src/context/tex/texmf-*/bin(N)
pathadd ~/.opam/default/bin ~/.cabal/bin ~/.go/bin ~/.npm_packages/bin ~/.cargo/bin ~/.elan/bin
pathadd ~/.babashka/bbin/bin
pathadd ~/.local/bin
pathadd ~/.gem/ruby/*/bin(Nn[-1])
pathadd ~/prj/mblaze{,/contrib}
pathadd ~/bin
pathadd ~/prj/necho

export GOPATH=~/.go:/usr/lib/go/site

# OCaml
export OPAM_SWITCH_PREFIX=~/.opam/default
export OCAML_TOPLEVEL_PATH=~/.opam/default/lib/toplevel
export CAML_LD_LIBRARY_PATH=~/.opam/default/lib/stublibs:/usr/lib/ocaml/stublibs:/usr/lib/ocaml

# Chicken Scheme
# 18apr2022  +leah+
export CHICKEN_INSTALL_REPOSITORY=~/.local/lib/chicken
export CHICKEN_REPOSITORY_PATH=$CHICKEN_INSTALL_REPOSITORY:/usr/lib/chicken/11

# Unix means English and 24h clock.  But do use UTF-8!  And sort like a machine.
export LANG=en_US.UTF-8
export LC_CTYPE=$LANG
export LC_COLLATE=C
export LC_TIME=C

# less: use UTF-8, no secondary screen,
# don't ignore case in man-db man(1) (which prepends -i to $LESS).
# 25jan2023  +leah+  add -R
export LESSCHARSET=UTF-8
export LESS=XR-+I

# 18mar2014  +leah+
# 20mar2014  +leah+
export MANSECT=8:2:3:1:1p:6:n:3perl:l:0:0p:5:4:9:7

# mdocml
# 08feb2015  +leah+
export PAGER=less
export MANPATH=/usr/local/share/man:/usr/share/man:/usr/lib/plan9/man

# 23may2017  +leah+
export MBLAZE_PAGER="less -RFXe"

# Nethack options
# 28oct2002  +leah+
export NETHACKOPTIONS=DECgraphics,!eight_bit_tty,time,!autopickup,color,showexp

export EDITOR=/usr/bin/vim

export NNTPSERVER=news.in-ulm.de                                                

export CVS_RSH=ssh

export SSH_ASKPASS=/usr/bin/gnome-ssh-askpass
export GNOME_SSH_ASKPASS_GRAB_SERVER=true

# XDG, 15jul2010
export XDG_DESKTOP_DIR="$HOME/DesktoP"
export XDG_DOWNLOAD_DIR="$HOME/mess/current"
export XDG_MUSIC_DIR="$HOME/Music"
# 16mar2025
export XDG_DATA_DIRS="/usr/local/share:/usr/share"
export XDG_CONFIG_DIRS="/etc/xdg"

# disable at-spi2 crap, 23jan2013
export NO_AT_BRIDGE=1

# no cleartype for us, 13sep2016  +leah+
export FREETYPE_PROPERTIES=truetype:interpreter-version=35

# TeX files
# 27apr2015  +leah+
export TEXMFHOME=~/.texmf
manpath+=(/opt/texlive/$TLYEAR/texmf-dist/doc/man)
# 20sep2022  +leah+
export OSFONTDIR="/usr/share/fonts;/opt/texlive/$TLYEAR/texmf-dist/fonts//;$HOME/.fonts"

# gcc colors
# 04aug2017  +leah+
export GCC_COLORS='locus=34'
# 17nov2017  +leah+
export GCC_COLORS=

# nix
# 07jan2019  +leah+
# 09may2021  +leah+
# 17feb2022  +leah+
export NIX_PATH=$HOME/.nix-defexpr
export NIX_USER_PROFILE_DIR="/nix/var/nix/profiles/per-user/$USER"
export NIX_PROFILES="/nix/var/nix/profiles/default $HOME/.nix-profile"
export NIX_REMOTE=daemon
export MANPATH=$HOME/.nix-profile/share/man:$MANPATH
fpath=(~/.nix-profile/share/zsh/site-functions $fpath)

# pipenv
# 12feb2019  +leah+
export PIPENV_VENV_IN_PROJECT=1

# pass
# 10jan2019  +leah+
export PASSWORD_STORE_X_SELECTION=primary

# sdcv
# 05sep2020  +leah+
export STARDICT_DATA_DIR=~/.local/share/dict

# nncp
# 12dec2025  +leah+
export NNCPCFG=~/.nncpcfg

# load various profiles
for rc in jdk plan9; do
  [ -r /etc/profile.d/$rc.sh ] && source /etc/profile.d/$rc.sh
done

# == SITE LOCAL CONFIG

[[ -e ~/.zshenv.local ]] && . ~/.zshenv.local || :
