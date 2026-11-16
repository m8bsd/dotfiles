alias ll="ls -la"
alias gs="git status"

# .zshrc interactive configuration file for zsh
# thanks to klapmuetz, caphuso, Mikachu, zshwiki.org.
# first revision: 24mar2007  +chris+

# == OPTIONS

setopt NO_BEEP
setopt C_BASES
setopt OCTAL_ZEROES
setopt PRINT_EIGHT_BIT
setopt SH_NULLCMD
setopt AUTO_CONTINUE
setopt NO_BG_NICE
setopt PATH_DIRS
setopt NO_NOMATCH
setopt EXTENDED_GLOB
disable -p '^'

setopt LIST_PACKED
setopt BASH_AUTO_LIST
# too slow: setopt HASH_EXECUTABLES_ONLY
setopt NO_AUTO_MENU
setopt NO_CORRECT
setopt NO_ALWAYS_LAST_PROMPT
setopt NO_FLOW_CONTROL

setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_MINUS

setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt INC_APPEND_HISTORY
setopt EXTENDED_HISTORY

SAVEHIST=9000
HISTSIZE=9000
HISTFILE=~/.zsh_history

LISTMAX=0
REPORTTIME=60
TIMEFMT="%J  %U user %S system %P cpu %MM memory %*E total"
MAILCHECK=0

# == MISC

umask 002

# This needs to run before compinit installs keybindings.
# 12mar2013  +chris+
bindkey -e

# == PROMPT

# gitpwd - print %~, limited to $NDIR segments, with inline git branch
# 09feb2024  +leah+  jj support, needs jj prompt
NDIRS=2
gitpwd() {
  local -a segs splitprefix jjdir; local gitprefix jjprefix branch
  segs=("${(Oas:/:)${(D)PWD}}")
  segs=("${(@)segs/(#b)(?(#c10))??*(?(#c5))/${(j:\u2026:)match}}")

  jjdir=( (../)#.jj(/N[-1]) )
  if [[ $jjdir ]]; then
    jjdir=( "${(s:/:)jjdir}" )
    branch=$(jj prompt 2>/dev/null)
    if (( $#jjdir > NDIRS )); then
      print -n "${segs[$#jjdir]}*$branch "
    else
      segs[$#jjdir]+="*$branch"
    fi
  elif gitprefix=$(git rev-parse --show-prefix 2>/dev/null); then
    splitprefix=("${(s:/:)gitprefix}")
    if ! branch=$(git symbolic-ref -q --short HEAD); then
      branch=$(git name-rev --name-only HEAD 2>/dev/null)
      [[ $branch = *\~* ]] || branch+="~0"    # distinguish detached HEAD
    fi
    if (( $#splitprefix > NDIRS )); then
      print -n "${segs[$#splitprefix]}@$branch "
    else
      segs[$#splitprefix]+=@$branch
    fi
  fi

  (( $#segs == NDIRS+1 )) && [[ $segs[-1] == "" ]] && print -n /
  print "${(j:/:)${(@Oa)segs[1,NDIRS]}}"
}

# 12feb2022  +leah+  disable PROMPT_SUBST, use psvar
nbsp=$'\u00A0'
cnprompt6() {
  case "$TERM" in
    xterm*|rxvt*|alacritty*)
      precmd_t() { [[ -t 1 ]] && print -Pn "\e]0;%m${TDIR:+ [$TDIR:h:t]}: %~\a" }
      preexec() { [[ -t 1 ]] && print -n "\e]0;$HOST: ${(q)2//[$'\t\n\r']/ }\a" }
  esac
  precmd_psvar() { psvar=( "$(gitpwd)" ) }
  PS1="%B%m${TDIR:+ [$TDIR:h:t]}%(?.. %??)%(1j. %j&.)%b %v%B%(!.%F{red}.%F{yellow})%#${SSH_CONNECTION:+%#}$nbsp%b%f"
  RPROMPT=''
}

cnprompt6

# == COMPLETION

zmodload zsh/complist
autoload -Uz compinit && compinit

zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*' special-dirs ..
zstyle ':completion:*' accept-exact-dirs true
zstyle ':completion:*' use-ip true
zstyle ':completion::*' insert-tab true
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' rehash true

zstyle ':completion:*:functions'           ignored-patterns '_*'
zstyle ':completion:*:*:*:*:processes*'    force-list always
zstyle ':completion:*:*:kill:*:processes'  insert-ids single
zstyle ':completion:*:*:kill:*:processes'  sort false
zstyle ':completion:*:*:kill:*:processes'  command 'ps -u "$USER"'
zstyle ':completion:*:processes-names'     command "ps -eo cmd= | sed 's:\([^ ]*\).*:\1:;s:\(/[^ ]*/\)::;/^\[/d'"
zstyle ':completion:*:evince::' \
  file-patterns '*.(#i)(dvi|djvu|tiff|pdf|ps|xps)(|.bz2|.gz|.xz|.z) *(-/)' '*'
compdef pkill=killall
compdef ping6=ping
compdef _gnu_generic emacs emacsclient file
compdef _precommand rlwrap

# Don't complete the same twice for kill/diff.
# 25nov2010  +chris+
zstyle ':completion:*:(kill|diff):*'       ignore-line yes

# Don't complete from PATH for sh and rc.
# 27mar2018  +leah+
zstyle ':completion:*:(sh|rc):*' tag-order '! commands builtins' -

# Don't complete backup files as commands,
# nor xbuild (instead complete to xbuildbarf).
# 29sep2012  +chris+
# 03nov2021  +leah+
zstyle ':completion:*:complete:-command-::*' ignored-patterns '*~' 'xbuild'

# Don't complete .pdf for less.
# 09apr2018  +leah+
zstyle ':completion:*:less:*' file-patterns '*~*.pdf'

# Lax completion for cd
# 23feb2019  +leah+
# 01mar2019  +leah+  fix uppercase completion
# 03mar2019  +leah+  use explicit tag-order
zstyle ':completion:*:cd:*' tag-order '*' '*:-case'
zstyle ':completion:*-case' matcher 'm:{a-zA-Z0-9}={A-Za-z0-9}' 'l:|=* r:|=*'

# Cycle through history completion (M-/, M-,).
# 12mar2013  +chris+
zstyle ':completion:history-words:*:history-words' stop yes
zstyle ':completion:history-words:*:history-words' list no
zstyle ':completion:history-words:*' remove-all-dups yes

# == ZLE

# Emacs keybindings have been set above.

# Disable bracketed paste.
# 31aug2015  +chris+
unset zle_bracketed_paste

# This is even better than copy-prev-shell-word, can be called repeatedly.
# 12mar2013  +chris+
autoload -Uz copy-earlier-word
zle -N copy-earlier-word
bindkey "^[m" copy-earlier-word

# Remove prompt on line paste (cf. last printed char in cnprompt6).
# 09mar2013  +chris+
bindkey -s $nbsp '^u'

# Shortcut for ' inside ' quoting
# 14mar2016  +chris+
bindkey -s "\C-x'" \''\\'\'\'

# Expand to two last commands
# 09nov2017  +leah+
bindkey -s "\C-x2" '!-2\t ; !-1\t'

# Standard keybindings
# 07apr2011  +chris+
# 04jan2013  +chris+  page-up/down for menu-select
# 14jan2016  +chris+  explicit binds for menu-select
[[ -n $terminfo[khome] ]] && bindkey $terminfo[khome] beginning-of-line
[[ -n $terminfo[kend]  ]] && bindkey $terminfo[kend]  end-of-line
[[ -n $terminfo[kdch1] ]] && bindkey $terminfo[kdch1] delete-char
[[ -n $terminfo[kpp]   ]] && bindkey $terminfo[kpp] backward-word
[[ -n $terminfo[knp]   ]] && bindkey $terminfo[knp] forward-word
[[ -n $terminfo[kpp]   ]] && bindkey -M menuselect $terminfo[kpp] backward-word
[[ -n $terminfo[knp]   ]] && bindkey -M menuselect $terminfo[knp] forward-word

# Move by physical lines, like gj/gk in vim
# 09apr2013  +chris+
_physical_up_line()   { zle backward-char -n $COLUMNS }
_physical_down_line() { zle forward-char  -n $COLUMNS }
zle -N physical-up-line _physical_up_line
zle -N physical-down-line _physical_down_line
bindkey "\e\e[A" physical-up-line
bindkey "\e\e[B" physical-down-line

# M-DEL should stop at /.
# 25mar2007  +chris+
# 28feb2011  +chris+
WORDCHARS="*?_-.[]~&;$%^+"

# backward-kill-default-word (with $WORDCHARS from zsh -f and :)
# 26jun2012  +chris+
_backward_kill_default_word() {
  WORDCHARS='*?_-.[]~=/&:;!#$%^(){}<>' zle backward-kill-word
}
zle -N backward-kill-default-word _backward_kill_default_word
bindkey '\e=' backward-kill-default-word   # = is next to backspace

# transpose-words acts on shell words
# 03mar2014  +chris+
autoload -Uz transpose-words-match
zstyle ':zle:transpose-words' word-style shell
zle -N transpose-words transpose-words-match

# History search with globs.
# 21sep2011  +chris+
# 05jun2012  +chris+  and keeping the rest of the line
# 22apr2016  +chris+  space for *
autoload -Uz narrow-to-region
_history-incremental-preserving-pattern-search-backward() {
  local state
  MARK=CURSOR  # magick, else multiple ^R don't work
  narrow-to-region -p "$LBUFFER${BUFFER:+>>}" -P "${BUFFER:+<<}$RBUFFER" -S state
  zle end-of-history
  zle history-incremental-pattern-search-backward
  narrow-to-region -R state
}
zle -N _history-incremental-preserving-pattern-search-backward
bindkey "^R" _history-incremental-preserving-pattern-search-backward
bindkey -M isearch "^R" history-incremental-pattern-search-backward
bindkey -M isearch -s ' ' '*'
bindkey -M isearch -s '  ' '[[:blank:]]'
bindkey "^S" history-incremental-pattern-search-forward

# Quote stuff that looks like URLs automatically.
# 19jul2008  +chris+
# 02dec2014  +chris+
autoload -U url-quote-magic
zstyle ':urlglobber' url-other-schema ftp git gopher http https magnet
zstyle ':url-quote-magic:*' url-metas '*?[]^(|)~#='  # dropped { }
zle -N self-insert url-quote-magic

# Edit command line with $VISUAL.
# 26jul2010  +chris+
autoload -z edit-command-line
zle -N edit-command-line
bindkey "^X^E" edit-command-line

# Force file name completion on C-x TAB, Shift-TAB.
# 23dec2010  +chris+
# 28may2016  +chris+  also complete words already on the command line
autoload -Uz match-words-by-style
_args() {
  local -a ign
  match-words-by-style
  [[ -z "$matched_words[3]" ]] && ign=("$matched_words[2]$matched_words[5]")
  compadd -F ign -- ${(Q)${(z)BUFFER}}
}
zle -C complete-files complete-word _generic
zstyle ':completion:complete-files:*' completer _files _args
zstyle ':completion:complete-files:*' force-list always
bindkey "^X^I" complete-files
bindkey "^[[Z" complete-files

# Force menu on C-f.
# 29dec2010  +chris+
# 21sep2011  +chris+
# 04jan2013  +chris+  rewritten using menu-select
zle -C complete-menu menu-select _generic
_complete_menu() {
  setopt localoptions alwayslastprompt
  zle complete-menu
}
zle -N _complete_menu
bindkey '^F' _complete_menu
bindkey -M menuselect '^F' accept-and-infer-next-history
bindkey -M menuselect '/'  accept-and-infer-next-history
bindkey -M menuselect '^?' undo
bindkey -M menuselect ' ' accept-and-hold
bindkey -M menuselect '*' history-incremental-search-forward

# Use skim(1) for menu completion.
# 12jan2020  +leah+
# 19feb2020  +leah+  fix with empty prefix
# 03may2022  +leah+  fix with tilde
# 18oct2023  +leah+  ignore *~ files
_complete_skim() {
  local wds=( ${(z)LBUFFER} )
  [[ $LBUFFER[-1] = ' ' ]] && wds+=( "" )
  local matches=(${(f)"$(\lr -HW -t 'name !~~ "*~"' ${~wds[-1]}* 2>/dev/null | sk --multi --reverse)"})
  [[ -n $matches ]] && (( $#wds[-1] )) && LBUFFER=${LBUFFER:0:-$#wds[-1]}
  [[ -n $matches ]] && LBUFFER+=${(@q)matches}
  zle reset-prompt
}
zle -N _complete_skim
(( $+commands[sk] )) && (( $+commands[lr] )) &&
bindkey '^F' _complete_skim

# Move to where the arguments belong.
# 24dec2010  +chris+
after-first-word() {
  zle beginning-of-line
  zle forward-word
}
zle -N after-first-word
bindkey "^X1" after-first-word

# Scroll up in tmux on PageUp.
# 14jan2016  +chris+
_tmux_copy_mode() { tmux copy-mode -eu }
zle -N _tmux_copy_mode
[[ $TMUX_PANE && -n $terminfo[kpp] ]] && bindkey $terminfo[kpp] _tmux_copy_mode

# fg editor on ^Z
# 27sep2011  +chris+
# 17feb2012  +chris+
foreground-vi() { fg %vi }
zle -N foreground-vi
bindkey '^Z' foreground-vi

# Allow to recover from C-c or failed history expansion (thx Mikachu).
# 26may2012  +chris+
_recover_line_or_else() {
  if [[ -z $BUFFER && $CONTEXT = start && $zsh_eval_context = shfunc
        && -n $ZLE_LINE_ABORTED
        && $ZLE_LINE_ABORTED != $history[$((HISTCMD-1))] ]]; then
    LBUFFER+=$ZLE_LINE_ABORTED
    unset ZLE_LINE_ABORTED
  else
    zle .$WIDGET
  fi
}
zle -N up-line-or-history _recover_line_or_else
_zle_line_finish() { ZLE_LINE_ABORTED=$BUFFER }
zle -N zle-line-finish _zle_line_finish

# Inject mkdir call to create the dirname of the current argument.
# 10mar2015  +chris+
autoload -Uz modify-current-argument
_mkdir_arg() {
  local arg=
  modify-current-argument '${arg:=$ARG}'
  zle push-line
  LBUFFER="    mkdir -p $arg:h"
  RBUFFER=
}
zle -N mkdir-arg _mkdir_arg
bindkey '^[M' mkdir-arg

# Keep an archive of all commands typed.
# Initialize using:
#   cat /data/dump/juno/2015<->/home/chris/.zsh_history | sort -u | grep '^:' |
#     gawk -F: '{print $0 >> "chris@juno-" strftime("%Y-%m-%d", $2)}'
# 04sep2015  +chris+
# 02sep2016  +chris+  store directory
# 01sep2019  +leah+  create dir if needed
[ -d ~/.zarchive ] || mkdir -p ~/.zarchive
zshaddhistory() {
  local words=( ${(z)1} )
  local w1=$words[1]
  (( $+aliases[$w1] )) && w1=$aliases[$w1]
  if [[ -n $1 && $1 != $'\n' && $w1 != " "* ]]; then
    printf ': %s:%s:0;%s' ${(%):-'%D{%s}'} ${(%):-%~} "$1" >> \
      ~/.zarchive/${(%):-%n@%m-'%D{%Y-%m-%d}'}
  fi
}

# za WORDS... - search .zarchive for WORDS
# 04sep2015  +chris+
# 02jul2024  +leah+  sort by date stamp
za() {
  grep -a -r -e "${(j:.*:)@}" ~/.zarchive |
    sed 's/[ \t]*$//' |
    sort -r | sort -t';' -k2 -u | sort -t'-' -k2 |
    sed $'s,^[^:]*/,,; s,::[^;]*;,\u00A0\u00A0,'
}
alias za=' za'

# zd [WORDS...] - list last commands in PWD from .zarchive
# 02sep2016  +chris+
# 02jul2024  +leah+  sort by date stamp
zd() {
  grep -a -r -e :${(%):-%~}: ~/.zarchive |
    sed 's/[ \t]*$//' |
    sort -r | sort -t';' -k2 -u | sort -t'-' -k2 |
    awk -F: -v dir=${(%):-%~} '$4 == dir && $5 ~ /^0;/' |
    sed $'s,^[^:]*/,,; s,::[^;]*;,\u00A0\u00A0,'
}
alias zd=' zd'

# == ALIASES

alias -g ':L'='|& less -F'
#alias -g ':R'='|& less -R'
alias -g ':C'='| wc -l'
(( $+commands[vdir] )) &&  # check for coreutils in path
alias ls='LC_COLLATE=C ls -F --dereference-command-line-symlink-to-dir' ||
alias ls='LC_COLLATE=C ls -FG'
alias mtr='mtr -t'
alias ping6='ping -6'
alias sort='LC_ALL=C sort'
(( $+commands[vim] )) && alias vi='vim'
alias texclean='rm -f *.toc *.aux *.log *.cp *.fn *.tp *.vr *.pg *.ky *.synctex.gz'
alias em='emacsclient -n'
alias dotf='ls .[a-zA-Z0-9_]*'
alias vil='vi *(.om[1]^D)'
alias cad='cat >/dev/null'
alias fq=nqtail
alias fssh='ssh -o Ciphers=chacha20-poly1305@openssh.com -o MACs=umac-64@openssh.com'
alias fscp=${aliases[fssh]/ssh/scp}
alias cssh='ssh -F /dev/null -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o PubkeyAuthentication=no'
alias cscp=${aliases[cssh]/ssh/scp}
alias d.='df -h . |sed 1d'
alias s.='du -sh .'
alias qr='qrencode -t UTF8'
alias pst='ps -o tname,user,bsdtime,pid,cmd -H'
alias exzsh='zsh -is eval \ zsh --version\; echo \$ZSH_PATCHLEVEL\; PS1="%#\ "'
alias zat='zathura --fork'
alias whatami='print gay'
alias clang='clang -fno-color-diagnostics -fno-caret-diagnostics'
alias clang++=${aliases[clang]/clang/clang++}
alias xwc='xsel | wc -c'
alias ncdu='NO_COLOR=1 ncdu'
alias xxd='NO_COLOR=1 xxd'
alias rg='rg --max-columns 200'
alias chez='chez-scheme'
(( $+commands[bsdtar] )) && alias tar=bsdtar
(( $+commands[sqlite] )) || alias sqlite=sqlite3
for cmd (coqtop ocaml MathKernel maxima bb pc growler-k ngn-k k q ${(Mk)commands:#k[67-]*})
  (( $+commands[$cmd] )) && alias $cmd="rlwrap $cmd"

autoload zmv
alias zzmv='noglob zmv -W'

# 29feb2008  +chris+
# 13apr2010  +chris+  allow completion
# 18dec2012  +chris+  set work tree too
alias homegit="GIT_DIR=~/prj/dotfiles/.git GIT_WORK_TREE=~ git"

hash -d mess=~/mess/current
hash -d uni=~/uni/current
hash -d phd=~/phd/current
hash -d wwwtmp=chneukirchen.org:/srv/http/chneukirchen.org/tmp

# e.g: echo *($SHUF)  (NB: slightly biased shuffle)
SHUF='oe|REPLY=${(l:5::0:)RANDOM}${(l:5::0:)RANDOM}${(l:5::0:)RANDOM}|'

# == FUNCTIONS

# j -- search jobs
# 15oct2017  +leah+  convert from alias
j() { jobs -l | grep ${@:-.} || echo no jobs running }

# mess -- switch to current mess folder, creating it if needed
# 17may2008  +chris+
mess phd () {
  set +e
  DIR=~/$0/$(date +%G/%V)
  [[ -d $DIR ]] || {
    mkdir -p $DIR
    ln -sfn $DIR ~/$0/current
    echo "Created $DIR."
  }
  cd ~/$0/current
}

# preserve cd -
# 21feb2011  +chris+
# 12feb2012  +chris+  save full dirstack, adopted from grml
# 02feb2013  +chris+  only add $PWD to file, better for multiple shells
DIRSTACKSIZE=9
DIRSTACKFILE=~/.zdirs
touch $DIRSTACKFILE
if [[ $#dirstack -eq 0 ]]; then
  dirstack=( ${(f)"$(< $DIRSTACKFILE)"} )
  [[ -d $dirstack[1] ]] && cd $dirstack[1] && cd $OLDPWD
fi
chpwd_dirstack() {
  local -a dirs; dirs=( "$PWD" ${(f)"$(< $DIRSTACKFILE)"} )
  print -l ${${(u)dirs}[0,$DIRSTACKSIZE]} >$DIRSTACKFILE
}

# translate -- grep de-en dictionary
# 22feb2010  +chris+
translate() { grep -i -w -e $1 ~/.translate.de-en } 

# mkcd -- mkdir and cd at once
# 16may2010  +chris+
# 12feb2012  +chris+
# 24jun2014  +chris+  mkcd it is
# 01may2020  +leah+  remove compdef mkcd=mkdir, it calls with --help!
mkcd() { mkdir -p -- "$1" && cd -- "$1" }
_mkcd() { _path_files -/ }
compdef _mkcd mkcd

# img -- display given or all images with the currently preferred viewer
# 01jun2010  +chris+
# 01apr2013  +chris+  back to feh
# 15sep2013  +chris+  back to qiv
# 30aug2017  +chris+  try pqiv
# img() { qiv -ftuNRi ${*:-.} }
img() { pqiv -flni ${*:-.} }

# h -- grep history
# 08mar2011  +chris+
# 14mar2011  +chris+
# 08dec2011  +chris+
# 19mar2014  +chris+  work without argument
h() { fc -l 0 -1 | sed -n "/${1:-.}/s/^ */!/p" | tail -n ${2:-10} }
alias h=' h'

# sucdo -- su -c like sudo without quotes
# 21mar2011  +chris+
# 29mar2016  +chris+  proper quoting
sucdo() { su -c "${(j: :)${(q)@}}" }
compdef sucdo=sudo

# zman -- easier browsing of zsh manpage
# 20sep2011  +chris+
# 16mar2015  +chris+  mdocml splits on any space in $PAGER
zman() { PAGER="less -g -s +/^\s{7}$1" man zshall }

# g -- call grep recursively with useful defaults
# 02oct2011  +chris+
# 10jan2012  +chris+  take an directory as possible last argument
# 28nov2012  +chris+  use grep -r
# 15dec2013  +chris+  use LC_ALL=C for speed and UTF-8 segfaults with -P
# 13may2015  +chris+  use directory only when more than two arguments
# 22feb2016  +chris+  line-buffered to quicker pipes
# 14aug2016  +chris+  same for git-grep
# 27sep2016  +chris+  '+ext' to expand to --include=*.ext
# 16nov2020  +leah+  use --cached by default
# 25jan2022  +leah+  override GIT_PAGER=less for gg so -O works nicely
g() {
  LC_ALL=C grep \
    ${${(M)@:#+*}:s/+/--include=*./} \
    --exclude "*~" --exclude "*.o" --exclude "tags" \
    --exclude-dir .bzr --exclude-dir .git --exclude-dir .hg --exclude-dir .svn \
    --exclude-dir CVS  --exclude-dir RCS --exclude-dir _darcs \
    --exclude-dir _build \
    --line-buffered -r -P ${${@:#+*}:?regexp missing}
}
gg() {
  local p=$argv[-1] o=
  (( ARGC > 1 )) && { git rev-parse -q --verify $p >/dev/null || [ -d $p ] } &&
    argv[-1]=() || { o='--cached'; p=; }
  LC_ALL=C GIT_PAGER=less git grep $o -P ${@:?regexp missing} $p
}

# gl -- find file names in Git
# 23sep2016  +chris+
gl() {
  local p=$argv[-1]
  (( ARGC > 1 )) && { p=$p/; argv[-1]=(); } || p=':/'
  git ls-files --exclude-standard "$p" | egrep "${@:-.}"
}

# d -- use g to find a definition (start of line, Go, Ocaml, Ruby, Rust)
# 07apr2014  +chris+
# 13may2015  +chris+
# 21jan2017  +leah+  ignore binary
# 10feb2018  +leah+  fix #define, better output
# 15aug2019  +leah+  revert output
d() {
  g -IHn '(^|(#define|\b(func|let|let rec|class|module|def|fn))\s+)'"$@"
}

# l -- find file names, recursively
# 20jun2012  +chris+  take a directory as possible last argument
# 05dec2019  +leah+  use lr -W
# 12nov2020  +leah+  use grep -a
l() {
  local p=$argv[-1]
# [[ -d $p ]] && { argv[-1]=(); } || p='.'
# find $p ! -type d | sed 's:^\./::' | egrep "${@:-.}"
  [[ -d $p ]] && { argv[-1]=(); } || p=''
  \lr -W -t 'type != d' $p | egrep -a "${@:-.}"
}

# v - vim -q from stdin
# 14aug2019  +leah+  use quickfix
# 15aug2019  +leah+
v() {
  vim --cmd "set efm=%f:%l:%c:%m,%f:%l:%m,%f:%s,%f" \
    -q <(if (( $# )); then printf '%s\n' "$@"; else cat; fi) </dev/tty
}

# browse l with vim
# 25mar2015  +chris+
# 14jul2015  +chris+
# 14aug2019  +leah+
# 27aug2025  +leah+  restore, revert to plain buffer
vl() { l "$@" | sort | vim - '+set nomod | map <buffer><C-M> <C-W>F<C-W>_' }

# lr -- a saner ls -R (using find)
# 07jun2013  +chris+
# 24oct2015  +chris+  prefer native implementation
(( $+commands[lr] )) ||
lr() {
  zparseopts -D -E S=S t=t r=r h=h U=U l=l F=F d=d
  local sort="sort -t/ -k2"                                # by name (default)
  local numfmt="cat"
  local long='s:[^/]* /::; s:^\./\(.\):\1:;'               # strip detail
  local classify=''
  [[ -n $F ]] && classify='/^d/s:$:/:; /^-[^ ]*x/s:$:*:;'  # dir/ binary*
  [[ -n $l ]] && long='s: /\(\./\)\?: :;'                  # show detail
  [[ -n $S ]] && sort="sort -n -k5"                        # by size
  [[ -n $r ]] && sort+=" -r"                               # reverse
  [[ -n $t ]] && sort="sort -k6" && { [[ -n $r ]] || sort+=" -r" } # by date
  [[ -n $U ]] && sort=cat                                  # no sort, live output
  [[ -n $h ]] && numfmt="numfmt --field=5 --to=iec --padding=6"  # human fmt
  [[ -n $d ]] && set -- "$@" -prune                        # don't enter dirs
  find "$@" -printf "%M %2n %u %g %9s %TY-%Tm-%Td %TH:%TM /%p -> %l\n" |
    $=sort | $=numfmt |
    sed '/^[^l]/s/ -> $//; '$long' '$classify
}
alias lr='lr -FGHPW'
# alias L='lr -FGHPl'
(( $+commands[lr] )) && alias l1='lr -FGHPl1' ||
l1() { lr -Fl "$@" -maxdepth 1; }
(( $+commands[lr] )) &&
lc() {
  lr -AFGH1s  -t '!type == d || depth > 0' "$@" |git column --mode=dense --pad=2
}

# lwho - utmp-free replacement for who(1)
(( $+commands[lr] )) && lwho() {
  lr -om -t 'name =~ "[0-9][0-9]*$" && uid != 0' \
     -f '%u\t%p\t%CF %CR\n' /dev/pts /dev/tty*
}

# svi -- edit pipe stream with vim
# 24jul2015  +chris+
svi() { () { vim $1 </dev/tty >/dev/tty && cat $1 } =(cat) }

# imv -- interactive rename, using vared
# 03sep2012  +chris+
# 21jul2014  +chris+
# 09dec2014  +chris+
# 24jul2019  +leah+
imv() {
  local src dst
  for src; do
    [[ -e $src ]] || { print -u2 "$src does not exist"; continue }
    dst=$src
    vared -f undefined-key dst
    [[ $src != $dst ]] && mkdir -p $dst:h && mv -n $src $dst &&
      print -s mv -n $src:q:q $dst:q:q   # save to history, thus M-. works
  done
}

# hl -- highlight regexps
# 06sep2012  +chris+
hl() { egrep --color=always -e '' -e${^*} }

# noq -- remove query string from filenames
# 01dec2012  +chris+
noq() { for f (${@:-*\?*}) mv -nv $f ${f%%\?*} }

# jkill -- kill all jobs of the current shell
# 23dec2012  +chris+
jkill() { kill "$@" %${(k)^jobstates} }

# k1 -- kill oldest job of the current shell
# 15dec2013  +chris+
k1() {
  local pids=${(j:,:)${jobstates#*:*:}%=*}
  kill "$@" ${(f)$(ps -o pid= --sort start -p $pids)[1]}
}

# jpid -- map job ids to pids
# 23dec2012  +chris+
jpid() {
  local p
  # $jobstates uses jobs.c:getjob() and can do %1 or %foo as well.
  for id; p+=(${${${jobstates[$id]}#*:*:}%=*})
  print $p
}

# zconvert -- zmv calling convert
# 05feb2013  +chris+
zconvert() {
  zparseopts -D n=n
  zmv -vf -W -p convert $n "-o ${*[1,-3]}" "$@[-2]" "$@[-1]"
}
alias zconvert='noglob zconvert'

# px -- verbose pgrep
# 17aug2016  +chris+  reformat VSZ,RSS, print elapsed
# 22mar2020  +leah+  use native px if available
px zpx() {
# ps uwwp ${$(pgrep -d, "${(j:|:)@}"):?no matches}
  ps wwp ${$(pgrep -d, "${(j:|:)@}"):?no matches} \
         -o pid,user:6,%cpu,%mem,vsz:10,rss:10,bsdstart,etime:12,bsdtime,args |
    sed '1s/     \(VSZ\|RSS\)/\1/g' |
    numfmt --header --field 5,6 --from-unit=1024 --to=iec --format "%5f"
}
(( $+commands[px] )) && unset -f px

# crun -- compile and run .c program
# 24oct2017  +leah+  fix for different dirs than .
crun() {
  local cprog=$1; shift
  local n=$@[(i)--]
  ${CC:-cc} -o ${cprog%.*} $cprog $@[1,n-1] && ${${cprog%.*}:a} $@[n+1,-1]
}

# tracing -- run zsh function with tracing
# 16mar2016  +chris+  keep return code
tracing() {
  local f=$1; shift
  functions -t $f
  $f "$@"
  local r=$?
  functions +t $f
  return $r
}

# bins -- list all executable files in $PATH as called by basename
bins() {
  rehash
  whence -p ${(kon)commands}
}

# up [|N|@|pat] -- go up 1, N or until basename matches pat many directories
#   just output directory when not used interactively, e.g. in backticks
# 06sep2013  +chris+
# 11oct2017  +leah+  add completion
# 13jul2021  +leah+  add @ for git root
# 12oct2023  +leah+  fix @ when in git root already
up() {
  local op=print
  [[ -t 1 ]] && op=cd
  case "$1" in
    '') up 1;;
    -*|+*) $op ~$1;;
    <->) $op $(printf '../%.0s' {1..$1});;
    @) local cdup; cdup=./$(git rev-parse --show-cdup) && $op $cdup;;
    *) local -a seg; seg=(${(s:/:)PWD%/*})
       local n=${(j:/:)seg[1,(I)$1*]}
       if [[ -n $n ]]; then
         $op /$n
       else
         print -u2 up: could not find prefix $1 in $PWD
         return 1
       fi
  esac
}
_up() { (( $#words > 2 )) || compadd -V segments -- ${(Oas:/:)PWD} }
compdef _up up
alias @='up @'

# dnext/dprev -- go to next/prev directory at same level
# 22dec2022  +leah+  normalize symlinks first
dnext() {
  local d; d=( ../*(/) )
  cd ${d[d[(i)../$PWD:A:t]${1:-+1}]:?no such dir}
}
alias dprev='dnext -1'

# n -- quickest note taker
# 21nov2013  +chris+
n() { [[ $# == 0 ]] && tail ~/.n || echo "$(date +'%F %R'): $*" >>~/.n }
alias n=' noglob n'

# allowcore -- permit coredumps
# 11jan2014  +chris+
allowcore() {
  for pid in $(pgrep "$@"); do
    prlimit --core=unlimited --pid $pid
  done
}

# killcore -- kill with a coredump
# 14nov2017  +leah+
killcore() { prlimit --core=unlimited --pid $1 && kill -ABRT $1 }

# 1G -- limit process to 1G RAM
# 01sep2017  +leah+
1G() { time softlimit -d $((1024*1024*1024)) -r $((1024*1024*1024)) -- "$@" }

# base NUM -- convert between bases
# 20jul2014  +chris+  zsh function
base() {
  setopt LOCAL_OPTIONS C_BASES OCTAL_ZEROES
  printf "%s = %08d %d 0%o 0x%x\n" $1 ${$(([#2] $1))#2\#} $(($1)) $(($1)) $(($1))
}

# count - count different lines
# 20jul2014  +chris+  zsh function
count() { sort "$@" | uniq -c | sort -n }

# f [FIELDS,FIELD-RANGE] - output nth fields
# 16mar2015  +chris+  zsh function
f() {
  perl -e '
    my $o = shift or do {print STDERR "Usage: $0 fields,field-range\n"; exit 1;};
    my @o = map { $_ > 0 ? $_-1 : $_ }
            map { /\d\K-/ ? $`..$'\'' : $_ }
            split ",", $o;
    
    while (<>) {
            chomp;
            print join(" ", (split)[@o]), "\n";
    }
  ' -- "$@"
}

# necho - a kind of sane echo
# 16mar2015  +chris+  zsh function
# 16mar2015  +chris+  split into three functions
# 18mar2015  +chris+  renamed from *utter
# 25mar2016  +chris+  jecho
# 20oct2017  +leah+  prefer binaries
(( $+commands[necho] )) || {
necho() { for a; do printf '%s\n' "$a"; done; }
zecho() { for a; do printf '%s\0' "$a"; done; }
qecho() { for a; do printf $'\u00bb%s\u00ab ' "$a"; done; printf '\n'; }
jecho() { printf '%s' "$@"; }
}

# srep N STR - print a string N times
# 22oct2017  +leah+
srep() { integer i=$1; while ((i--)); do printf %s $2; done }

# unsplit SEP FILES... - cat with separators
# 01oct2017  +leah+
unsplit() { cat $2; for a in $@[3,-1]; do printf "%s" $1; cat $a; done }

# imgur - post image to imgur.com
# 20jul2014  +chris+  zsh function
# 01apr2016  +chris+  use api v3
imgur() {
  curl -H "Authorization: Client-ID 3e7a4deb7ac67da" -F image=@$1 \
    https://api.imgur.com/3/upload | sed 's/.*http/http/; s/".*/\n/; s,\\/,/,g'
}

# keep - poor man's version control, make freshly numbered copies
# 20jul2014  +chris+
# 08feb2019  +leah+  err when no arguments are given
keep() {
  local f v
  [[ $# = 0 ]] && return 255
  for f; do
    f=$f:A
    v=($f.<->(nOnN[1]))
    if [[ -n "$v" ]] && cmp $v $f >/dev/null 2>&1; then
      print -u2 $v not modified
    else
      cp -va $f $f.$((${${v:-.0}##*.} + 1))
    fi
  done
}

# sprunge FILES... - paste to sprunge.us
# 20jul2014  +chris+  zsh function
# 24nov2016  +chris+  use awk
sprunge() {
  awk -- 'ARGC>2 && FNR==1 {print "## " FILENAME} 1' "$@" |
    curl -sF 'sprunge=<-' http://sprunge.us | tr -d ' '
}

# 0x0 FILE - paste to 0x0.st
# 16dec2015  +chris+
0x0() { curl -F "file=@${1:--}" https://0x0.st/ }

# ixio FILE - paste to ix.io
# 02apr2018  +leah+
ixio() { curl -F "f:1=@${1:--}" http://ix.io/ }

# clbin FILE - paste to clbin.com
# 25sep2019  +leah+
clbin() { curl -F "clbin=<${1:--}" https://clbin.com }

# stee - silent tee
# 20jul2014  +chris+  zsh function
# 24jun2015  +chris+  mkdir -p the target file directories
stee() { mkdir -p "$@:h" && tee "$@" >/dev/null }

# total [-F<sep>] [FIELDNUM] - sum up numbers in a column
# 20jul2014  +chris+  zsh function
total() {
  local F
  expr "$1" : -F >/dev/null && F=$1 && shift
  awk $F -v f=${1:-1} '{s+=$f} END{print s}'
}

# uncolor - remove ANSI color escapes
# 15jan2024  +leah+
uncolor() { sed "s/\x1B\[\([0-9]\{1,2\}\(;[0-9]\{1,2\}\)\?\)\?[mGK]//g" "$@" }

# unfmt - convert paragraphs into long lines
# 20jul2014  +chris+  zsh function
# 15dec2014  +chris+  simplify
unfmt() { perl -00pe 's/\s*\n\s*/ /g; s/\s*\Z/\n/;' -- "$@" }

# words - print all words on separate lines
# an alternative is fmt -1, but words strips whitespace
# 27feb2020  +leah+
words() { perl -nE 'say for split' }

# zombies - list all zombies and their parents to kill
# 23jul2014  +chris+  zsh function
# 23mar2024  +leah+  fix for ps not printing <defunct> anymore
zombies() {
  ps f -eo state,pid,ppid,comm | awk '
    { cmds[$2] = $NF }
    /^Z/ { print $NF "/" $2 " zombie child of " cmds[$3] "/" $3 }'
}

# zpass - generate random password
# 01nov2014  +chris+
# 10mar2017  +leah+  default to length 12
zpass() {
  LC_ALL=C tr -dc '0-9A-Za-z_@#%*,.:?!~' </dev/urandom | head -c${1:-12}
  echo
}

# zmac - generate random mac (QEMU OUI)
# 12may2021  +leah+
zmac randmac() { xxd -p -l 3 </dev/urandom | sed 's/../:&/g; s/^/52:54:00/' }

# cde - cd to working directory of current emacs buffer
# 11nov2014  +chris+
# 13dec2017  +leah+  print when not on a tty
# 26nov2019  +leah+  append $1
cde() {
  local op=print
  [[ -t 1 ]] && op=cd
  $op ${(A):-${(Q)~$(emacsclient -e '(with-current-buffer
                                       (window-buffer (selected-window))
                                       default-directory) ')}${1:-/.}}
}

# cdp - cd to emacs's current-project
# 06apr2022  +leah+
# 05mar2024  +leah+  use project-root
cdp() {
  local op=print
  [[ -t 1 ]] && op=cd
  $op ${(A):-${(Q)~$(emacsclient -e '(with-current-buffer
                                       (window-buffer (selected-window))
                                       (if-let ((prj (project-current)))
                                         (project-root prj)
                                         default-directory)) ')}${1:-/.}}
}

# ecat - print current emacs buffer
# 15aug2016  +chris+
ecat() {
  () {
    emacsclient -e '(with-current-buffer (window-buffer (selected-window))
                      (write-region (point-min) (point-max) "'$1'" nil :quiet))
                   ' >/dev/null &&
    cat $1
  } =(:)
}

# null - throw away input
# 01dec2014  +chris+
null() { LC_ALL=C tr -cd '' }

# absolute [FILE...] - print absolute file name/PWD
# 02dec2014  +chris+
# 18oct2016  +chris+  also abspath
# 18nov2016  +chris+  print hostname to tty when logged in via ssh
absolute abspath () {
  [[ -n "$SSH_CONNECTION" ]] && [[ -t 1 ]] && local prefix="$(hostname -f):"
  print -l $prefix${^${@:-$PWD}:a}
}

# homediff FILE
# 02dec2014  +chris+
# 26feb2019  +leah+
homediff() {
  diff -u "${1?no file given}" <(curl -sL http://leahneukirchen.org/dotfiles/$1)
}

# ssh-copy-term - copy terminfo via ssh
# 10dec2014  +chris+
ssh-copy-term() {
  infocmp $TERM | ssh "$@" 't="$(mktemp)" && cat >"$t" && tic -s "$t"'
} 

# cppdef - print predefined C macros
# 09mar2015  +chris+
# 31mar2016  +chris+  use $1 as cc
cppdef() { ${1:-cc} $@[2,-1] -dM -E - </dev/null }

# cppgrep - grep in C/C++ headers
# 10aug2017  +leah+
cppgrep() {
  printf '#include "%s"' "$@[2,-1]" | gcc -E -M -MP -x c++ - |
    awk -F: '/:$/ {print $1}' | xe -N0 grep -nP "$1"
}

# crustdiff - diff of uncrustify result
# 31aug2017  +leah+
crustdiff() { for f; uncrustify -f $f | diff -u $f - }

# perltidydiff - diff of perltidy result
# 15dec2019  +leah+
perltidydiff() { for f; perltidy < $f | diff -u --label $f --label $f $f - }

# ltime - start and run time of last commands
# 05feb2018  +leah+  use tail -n
ltime() { fc -liDI 1 | tail -n ${1:-10} }

# zapply [-jN] [-iv] CMD... -- ARGS... - run up to N CMD in parallel with ARGS
#   CMD will be run as zsh command if it contains a $
#   without explicit '--', assume CMD is first argument
#   {} (or $1) may be used to access argument
# 01apr2015  +chris+
zapply() {
  local s="$@[(i)--]" xopt=
  (( s > $# )) && argv[2]=(-- "$argv[2]") && s=2
  zparseopts -D -M -A xopt n: p t P: j:=P v=t i=p   # map to xargs(1) flags
  (( $@[(i){}] < s )) && xopt[-I]={}
  [[ $1 = *'$'* ]] && argv[1]=(zsh -c "$1" --) && (( s += 3 ))
  printf '%s\0' "$@[s+1,-1]" | xargs -0 -r -n1 ${(kv)=xopt} "$@[1,s-1]"
}

# gman - format manpage using GNU troff
# 10apr2015  +chris+
gman() {
  ( man -w "$@" 2>/dev/null || printf '%s\n' "$@" ) |
    xargs cat |
    groff -t -p -I/usr/share/man -Tutf8 -mandoc | less
}

# myman - format manpage of own projects
# 22feb2016  +chris+
# 27jul2016  +chris+  mandoc doesnt like being called from xe
#myman() { locate -0 -e $HOME/*/$1.[0-9] | xe -0RN0 man -l }
#myman() { man -l $(locate -e $HOME/*/$1.[0-9]) }
myman() { man -l $(locate $HOME/*/$1.[0-9]) }

# twoman - show inline "manpage"
# 13feb2017  +leah+
twoman() {
  for cmd; do
    sed -n '1{/^[^#][^!]/q;d};0,/^$\|^[^#]/s/^# //p' ${commands[$cmd]?not found}
  done
}

# soak [OUTPUT] - write stdin to OUTPUT (or stdout), not clobbering OUTPUT.
# Also don't clobber on empty input.
# 03may2015  +chris+
soak() {
  perl -we 'undef $/; my $s = <STDIN>;
            $ARGV[0] and $s and open(STDOUT, ">", $ARGV[0]) || die "soak: $!\n";
            print $s;' -- "$@"
}

# inp FILE FILTER... - run FILTER in-place on FILE
# 16mar2016  +chris+
inp() { () { "$@[3,-1]" <$2 >$1 && [[ -s $1 ]] && mv $1 $2 } =(:) "$@" }

# sslcat HOST:PORT - print SSL certificate and details
sslcat() {
  local cert="$(openssl s_client -connect $1 </dev/null | awk '/^--*BEGIN/,/^--*END/')"
  printf '%s\n' "$cert" | openssl x509 -in /dev/stdin -text
  printf '%s\n' "$cert" | openssl x509 -in /dev/stdin -noout -sha1 -fingerprint
  printf '%s\n' "$cert" | openssl x509 -in /dev/stdin -noout -md5 -fingerprint
}

# clot - fill screen with garbage, as visual separator
# 17aug2015  +chris+
# 11mar2016  +chris+ print seperate lines
clot() {
  head -c $((LINES*COLUMNS)) </dev/urandom |
    LC_ALL=C tr '\0-\377' ${(l:256::.*o@:)} |
    fold -w $COLUMNS
}

# spot - show changes compared to previous line
# 03nov2017  +leah+
spot() {
  awk '{ for (i = 1; i <= length($0); i++)
           printf("%c", ((l = substr($0, i, 1))!=" " && l!="\t" &&
                          substr(p, i, 1)==l ? "." : l))
         printf("\n"); p = $0; }'
}

# suf FILENAME [SUFFIX] - replace or add suffix
# 02jan2018  +leah+
suf() { print "${1%.*}${2:+.$2}" }

# mdless - read markdown with less
mdless() { pandoc -s -f gfm -t man "$@" | man -l }

# ghmd - format GitHub markdown
# 31oct2016  +chris+
ghmd() { 
  printf '%s' '<html><head><meta charset="utf-8">' \
    '<link href="https://dl.dropboxusercontent.com/u/8554242/temp/' \
    'github-flavored-markdown.css" media="all" rel="stylesheet" ' \
    'type="text/css" /><link ' \
    'href="//cdnjs.cloudflare.com/ajax/libs/octicons/2.1.2/octicons.css" ' \
    'media="all" rel="stylesheet" type="text/css" /></head><body><article ' \
    'class="markdown-body entry-content" style="padding: 30px;">'
  curl -s --data-binary @- -H 'Content-Type: text/plain' \
    https://api.github.com/markdown/raw
}

# mudoc - read .doc with mupdf
# 07dec2016  +chris+
mudoc() { mupdf =(antiword -a a4 -m 8859-1 "$@") }

# mupdf - appear as mu-pdf in cwm window list
# 08aug2017  +leah+
# 09apr2018  +leah+  fix completion
alias mupdf=mu-pdf
compdef mu-pdf=mupdf
mu-pdf() { =mupdf "$@" }

# mcal [MONTH] - show calendar for this year's MONTH
# 12dec2017  +leah+  start with Monday
mcal() { cal -m "$@" $(date +%Y) }

# padd [CMD] - allow to run CMD without being in path
typeset -A padds
padd() { padds[$1:t]=$1:A; rehash }
rehash() { local c p; builtin rehash "$@" && for c p (${(kv)padds}) hash $c=$p }

# ghtodo - convert lines into a github todo format
# 09jan2016  +chris+
# 13jan2018  +leah+
ghtodo() { sed '/./s/^\(- \)\?/- [ ] /' }

# ghkeys - display github keys
# 23jun2017  +leah+
ghkeys() { curl https://github.com/${^@}.keys }

# cdate - timestamp in my format
# 09jan2016  +chris+
cdate() { print ${(L)${(%):-'%D{%d%b%Y}'}} " +$USER+" }

# dottime - a universal convention for conveying time
# https://dotti.me/
# 31aug2019  +leah+
dottime() {
  ( export TZ=GMT; print -Pn $'%D{%Y-%m-%dT%H\u00B7%M}' )
  print ${${(%):-%D{%z}}%00}
}

# curlmini - fetch gemini with curl
# 22sep2022  +leah+
curlmini() { curl -k gophers://${${1#gemini://}%%/*}:1965/0$1 | less }

# cat0 - print nul-delimited data linewise
# 14jun2016  +chris+  take filenames
cat0() { cat "$@" | LC_ALL=C tr '\000' '\012' }

# faketty - run command such that isatty() is true
# 29mar2016  +chris+
# 16oct2025  +leah+  use -e to keep status
faketty() { script -qfec "${(j: :)${(q)@}}" /dev/null }

# notty - run command without controlling tty
# 29nov2017  +leah+
notty() { s6-cat | setsid -w "$@" | s6-cat }

# chop - limit lines to terminal size
# 14jun2016  +chris+
chop() { cut -c-${COLUMNS:-80} }

# wrap - wrap long lines using backslashes
wrap() { perl -pe 's/.{'$(( ${COLUMNS:-80} - 1))'}/$&\\\n/g' -- "$@" }

# meowth - a better cat -vET
# 30nov2016  +chris+
meowth() {
  perl -CO -MEncode -pe '
    $e=0; $w=4; eval { $_ = decode("UTF-8", $_, Encode::FB_CROAK) } or $w=2;
    s/[\x01-\x08\x0E-\x1F\x{80}-\x{FFFFFF}\x80-\xFF]/
      sprintf "\x{29fc}%0${w}X\x{29fd}",ord $&/eg;
    1 while s/\t/"\x{2014}" x ((length($&)*8 - length($`)%8)-1) . "\x{00BB}"/e;
    s/\x0c$/("\x{22EF}"x78)/eg;
    y/ \x00\x0b\x0c\r/\x{00B7}\x{2400}\x{240B}\x{240C}\x{240D}/;
    s/\n$/\x{23CE}\n/ and $e=1;
    END { $e or print "\x{2205}\n"}
  ' -- "$@"
}

# ud - unicode dump
# 04apr2018  +leah+
ud() { uconv -x ':: [^\x0a\x20-\x7f] any-name;' "$@" }

# pcat - cat with file name prefix
# 29nov2017  +leah+
# 23dec2017  +leah+  detect missing trailing newlines
# 07jan2023  +leah+  detect directories
pcat() { perl -pe 's/^/$ARGV\t/' -- "$@" }
pcat() {
  perl -we 'push @ARGV, "-"  unless @ARGV;
            for $f (@ARGV) {
              open my $fh, "<", ($f eq "-" ? "/dev/stdin" : $f)
                or warn "$f: $!.\n" and next;
              -d $fh and warn "$f is a directory\n" and next;
              my $l = "";
              print "$f\t", $l=$_  while (<$fh>);
              if ($. == 0) {
                warn "$f is empty\n";
              } elsif ($l !~ /\n\z/) {
                print "\n";
                warn "$f has no trailing newline\n"
              }
            }' -- "$@"
}

# wsort - sort words in line
# 19aug2016  +chris+
wsort() { perl -nE 'say join(" ",sort(split))' "$@" }

# twap - print all but first and last line twice (e.g. lr | twap | xe -N2 diff)
# 11may2018  +leah+
twap() { awk 'l!=0{print l} NR>1{l=$0} 1' }

# 256colors - display the 256 terminal colors
# 02aug2016  +chris+
256colors() {
  for i in {0..255}; do
    printf "\033[48;5;%dm\033[38;5;15m %03d " $i $i
    printf "\033[33;5;0m\033[38;5;%dm %03d " $i $i
    (( i+1 <= 16 ? (i+1) % 8 :  ((i+1)-16) % 6  )) || printf "\033[0m\n"
    (( i+1 <= 16 ? (i+1) % 16 : ((i+1)-16) % 36 )) || printf "\033[0m\n"
  done
}

# debtar - output tar of .deb
# 08aug2017  +leah+
debtar() { bsdtar xOf $1 'data.tar.*' }

# revpatch - reverse a patch
# 24may2020  +leah+
revpatch() { interdiff -q $1 /dev/null }

# s - read mblaze mail from xlbiff
# 23may2017  +leah+
# 02jun2017  +leah+  simplify
# 22may2020  +leah+  add ,,
s() {
  (
    export MAILSEQ=$HOME/.mblaze/xlseq
    case "$1" in
      '') mscan;;
      ''|<->) mshow $@;;
      *) "$@";;
    esac
  )
}
alias ,,=' mflag -S .'

# ts - prepend timestamps
# 24feb2020  +leah+
ts() { s6-tai64n | s6-tai64nlocal "$@" }

# nu - number lines, right aligned
# 21jun2024  +leah+
nu() { perl -e '$l=length(@L = <>); printf "%*d %s",$l,++$i,$_ for @L;' -- "$@" }

# ipv4addrs - grep for IPv4 addresses
ipv4addrs() { grep -Po '\b(?<!\.)(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)(?!\.)\b' }

# sourceenv - load and export environment variables from a file
# 03mar2023  +leah+
sourceenv() {
  local __file
  setopt localoptions allexport
  for __file; do
    source $__file
  done
}

# zz - smart directory changer
# 14dec2015  +leah+
# 15dec2015  +leah+ clean up nonexisting paths
# 23oct2020  +leah+ don't lose data when disk is full
chpwd_zz() {
  print -P '0\t%D{%s}\t1\t%~' >>~/.zz
}
zz() {
  awk -v ${(%):-now='%D{%s}'} <~/.zz '
    function r(t,f) {
      age = now - t
      return (age<3600) ? f*4 : (age<86400) ? f*2 : (age<604800) ? f/2 : f/4
    }
    { f[$4]+=$3; if ($2>l[$4]) l[$4]=$2 }
    END { for(i in f) printf("%d\t%d\t%d\t%s\n",r(l[i],f[i]),l[i],f[i],i) }' |
      sort -k2 -n -r | sed 9000q | sort -n -r -o ~/.zz- && mv ~/.zz- ~/.zz
  if (( $# )); then
    local p=$(awk 'NR != FNR { exit }  # exit after first file argument
                   { for (i = 3; i < ARGC; i++) if ($4 !~ ARGV[i]) next
                     print $4; exit }' ~/.zz ~/.zz "$@")
    [[ $p ]] || return 1
    local op=print
    [[ -t 1 ]] && op=cd
    if [[ -d ${~p} ]]; then
      $op ${~p}
    else
      # clean nonexisting paths and retry
      while read -r line; do
        [[ -d ${~${line#*$'\t'*$'\t'*$'\t'}} ]] && print -r $line
      done <~/.zz | sort -n -r -o ~/.zz- && mv ~/.zz- ~/.zz
      zz "$@"
    fi
  else
    sed 10q ~/.zz
  fi
}
alias z=' zz'

# .t - a wrapper for project-specific shell configuration (t-fns)
# 31mar2017  +leah+
# 03apr2017  +leah+
# 04apr2017  +leah+
# 16apr2017  +leah+  use ./.t/
# 25feb2019  +leah+  rename t to .t
# 19mar2019  +leah+  set TDIR (formerly TENV) in __t
# 02may2019  +leah+  fix when only rc exists
__t() {
  TDIR=( ./(../)#.t(/N[-1]:A) )
  tfns=( $TDIR/../.t/*[^~]~*/rc(N:t) )
  unfunction -- $tfns 2>/dev/null
  [[ -n $TDIR && -n $tfns ]] && autoload -Uz -- $TDIR/$^tfns
  [[ -r $TDIR/../.t/rc ]] && . $TDIR/rc || :
  cnprompt6  # XXX move to psvar 17feb2022 +leah+
}
.t() {
  (
    if [[ -d $1 ]]; then                # activate dir
      cd $1 && zsh -is __t
    elif (( $# )); then                 # run function
      __t && eval "$@"
    else                                # list functions
      __t && print -l -- ${(o)tfns}
    fi
  )
}
_t() {
  _arguments -S \
    ':command:{ compadd -- $(.t) || _path_files -/ || _command_names -e }' \
    '*::arguments:_normal'
}
compdef _t .t
[[ $1 == __t ]] && __t                  # entry-point for zsh -is __t
# 25feb2019  +leah+
alias t.='exec .t .'

# wat - a better and recursive which/whence
# 13apr2017  +leah+
# 02jan2018  +leah+  print function code
wat() {
  ( # constrain unalias
  for cmd; do
    if (( $+aliases[$cmd] )); then
      printf '%s: aliased to %s\n' $cmd $aliases[$cmd]
      local -a words=(${${(z)aliases[$cmd]}:#(*=*|rlwrap|noglob|command)})
      unalias $cmd
      if [[ $words[1] == '\'* ]]; then
        words[1]=${words[1]#'\'}
        unalias $words[1] 2>/dev/null
      fi
      wat $words[1]
    elif (( $+functions[$cmd] )); then
      whence -v $cmd
      whence -f $cmd
    elif (( $+commands[$cmd] )); then
      wat $commands[$cmd]
    elif [[ -h $cmd ]]; then
      file $cmd
      wat $cmd:A
    elif [[ -x $cmd ]]; then
      file $cmd
    else
      which $cmd
    fi
  done
  )
}
compdef wat=which

# collect all chpwd_* hooks
chpwd_functions=( ${(kM)functions:#chpwd?*} )

# collect all precmd_* hooks
precmd_functions=( ${(kM)functions:#precmd?*} )

# == SPECIAL ENVIRONMENTS

case "$TERM" in
  9term|win)
    chpwd() { awd }
    ;&
  network|dumb)
    export LS_COLORS=
    zstyle -d ':completion:*' list-colors
    zstyle -d ':completion:*:default' list-colors
    alias ls="LC_COLLATE=C /bin/ls -F --color=never"

    setopt SINGLE_LINE_ZLE NO_PROMPT_CR NO_BASH_AUTO_LIST
    _expand_or_complete_newline() {
      zle expand-or-complete
      echo
      zle reset-prompt
    }
    zle -N expand-or-complete-newline _expand_or_complete_newline
    bindkey "^D" expand-or-complete-newline
    export PAGER=cat
    export GIT_PAGER=cat

    PS1="%m%(?.. %??)%(1j. %j&.) %${NDIRS:-2}~%#${SSH_CLIENT:+%#} "

    alias vi="TERM=xterm gvim -p"
    alias vim=vi
    alias lf="9 lc -F"
esac

# Interactive zsh, but automatically execute given command.
# zsh -is eval $COMMAND
# c.f. http://www.zsh.org/mla/users/2005/msg00599.html
# 12jan2013  +chris+
if [[ $1 == eval ]]; then
  shift
  ICMD="$@"
  set --
  zle-line-init() {
    BUFFER="$ICMD"
    zle accept-line
    zle -D zle-line-init
  }
  zle -N zle-line-init
fi

# == SITE LOCAL CONFIG

[[ -e ~/.zshrc.local ]] && . ~/.zshrc.local || :
