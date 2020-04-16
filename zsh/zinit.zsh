# zsh/zinit.zsh

export DKO_SOURCE="${DKO_SOURCE} -> zinit.zsh {"

# ----------------------------------------------------------------------------
# Docker
# ----------------------------------------------------------------------------

zinit has'docker' for \
  silent as'completion' is-snippet \
  'https://github.com/docker/cli/blob/master/contrib/completion/zsh/_docker' \
  lucid from'gh-r' as'program' 'jesseduffield/lazydocker'

# ----------------------------------------------------------------------------
# Git
# ----------------------------------------------------------------------------

# Official GitHub CLI
cli_bpick=""
# zinit gets the deb instead of the tar.gz
[[ "$DOTFILES_OS" == "Linux" ]] && cli_bpick="bpick'*_linux_amd64.tar.gz'"
zinit lucid from'gh-r' as'program' for \
  "$cli_bpick" \
  pick'gh/bin/gh' mv'gh* -> gh' \
  '@cli/cli'
unset cli_bpick

zinit lucid has'git' as'program' pick for \
  'davidosomething/git-ink' \
  'davidosomething/git-my' \
  'davidosomething/git-relevant' \
  'davidosomething/git-take' \
  'paulirish/git-open' \
  'paulirish/git-recent'

zinit lucid has'git' as'program' \
  pick"${ZPFX}/bin/git-*" \
  src'etc/git-extras-completion.zsh' \
  make"PREFIX=${ZPFX}" \
  for 'tj/git-extras'

# ----------------------------------------------------------------------------
# FZF and friends
# ----------------------------------------------------------------------------

# Binary release in archive, from GitHub-releases page.
# After automatic unpacking it provides program "fzf".
! __dko_has fzf && zinit lucid from'gh-r' as'program' for \
  'junegunn/fzf-bin'

# gi is my git-ink alias, and i don't need a .gitignore generator
export forgit_ignore='fgi'
# fzf-git -- `` compl for git commands
zinit lucid for \
  'wfxr/forgit' \
  'hschne/fzf-git' \
  'torifat/npms'

# ----------------------------------------------------------------------------
# Misc
# ----------------------------------------------------------------------------

# my fork of cdbk, ZSH hash based directory bookmarking. No wait!
export ZSH_BOOKMARKS="${HOME}/.local/zshbookmarks"
zinit lucid light-mode for 'davidosomething/cdbk'

export _ZO_DATA="${XDG_DATA_HOME}/zoxide"

# no wait, want programs available so i can type before prompt ready
zinit lucid from'gh-r' as'program' for \
  pick'bat/bat' mv'bat* -> bat' \
  atclone'cp -vf bat/bat.1 $ZPFX/share/man/man1' atpull'%atclone' \
  '@sharkdp/bat' \
  \
  pick'delta*/delta' \
  atload'export GIT_PAGER="delta --dark"' \
  'dandavison/delta' \
  \
  pick'fd/fd' mv'fd* -> fd' \
  atclone'cp -vf fd/fd.1 $ZPFX/share/man/man1' atpull'%atclone' \
  '@sharkdp/fd' \
  \
  mv'jq* -> jq'             'stedolan/jq' \
  mv'nvim-ctrl* -> nvctl'   'chmln/nvim-ctrl'   \
  mv'shfmt* -> shfmt'       '@mvdan/sh'         \
  \
  mv'zoxide* -> zoxide' \
  atload'eval "$(zoxide init zsh)" && alias j=z' \
  'ajeetdsouza/zoxide'

! __dko_has rg && zinit lucid from'gh-r' as'program' pick'ripgrep*/rg' for \
  'BurntSushi/ripgrep'

zinit lucid nocompletions light-mode for '@shannonmoeller/up'

# ----------------------------------------------------------------------------
# ZSH extensions
# ----------------------------------------------------------------------------

zinit lucid trigger-load'!man' for is-snippet \
  'OMZ::plugins/colored-man-pages/colored-man-pages.plugin.zsh'

# In-line best history match suggestion
# don't suggest lines longer than
export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=78
# as of v4.0 use ZSH/zpty module to async retrieve
export ZSH_AUTOSUGGEST_USE_ASYNC=1
# Removed forward-char
export ZSH_AUTOSUGGEST_ACCEPT_WIDGETS=(vi-end-of-line)

export ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# ! will track the loading since using zinit load
zinit lucid wait \
  atload'_zsh_autosuggest_start && bindkey "^n" autosuggest-accept' for \
  'zsh-users/zsh-autosuggestions'

# ----------------------------------------------------------------------------
# Vendor: Completion
# ----------------------------------------------------------------------------

zinit lucid wait blockf atpull'zinit creinstall -q .' for \
  'zsh-users/zsh-completions'

[[ -f "${TRAVIS_CONFIG_PATH}/travis.sh" ]] &&
  zinit lucid wait for "$TRAVIS_CONFIG_PATH"

zinit silent has'keybase' as'completion' is-snippet for \
  'https://github.com/zeroryuki/zsh-keybase/blob/master/_keybase'

# ----------------------------------------------------------------------------
# Syntax last, and compinit before it
# ----------------------------------------------------------------------------

# don't add wait, messes with zsh-autosuggest
zinit lucid atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" for \
  'zdharma/fast-syntax-highlighting'

DKO_SOURCE="${DKO_SOURCE} }"
