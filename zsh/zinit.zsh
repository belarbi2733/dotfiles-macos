# zsh/zinit.zsh

# Order of execution of related Ice-mods: atinit -> atpull! -> make'!!' -> mv
# -> cp -> make! -> atclone/atpull -> make -> (plugin script loading) -> src
# -> multisrc -> atload.

export DKO_SOURCE="${DKO_SOURCE} -> zinit.zsh {"

__load_zinit_plugins() {
  # Make man dir in /polaris
  mkdir -pv "${ZPFX}/share/man/man1"

  # ----------------------------------------------------------------------------
  # Docker
  # ----------------------------------------------------------------------------

  zinit lucid has'docker' for \
    as'completion' is-snippet \
    'https://github.com/docker/cli/blob/master/contrib/completion/zsh/_docker' \
    \
    as'completion' is-snippet \
    'https://github.com/docker/compose/blob/master/contrib/completion/zsh/_docker-compose' \
    \
    from'gh-r' as'program' \
    'jesseduffield/lazydocker' \
    \
    from'gh-r' as'program' \
    mv'hadolint* -> hadolint' \
    'hadolint/hadolint' \
    ;

  # ----------------------------------------------------------------------------
  # Git
  # ----------------------------------------------------------------------------

  # must specify the gh* directory so we don't get old version in
  # cli--cli/.backup
  local gh_pick="gh*/**/gh"
  [ "$DOTFILES_OS" = 'Linux' ] && gh_pick='usr/bin/gh'

  zinit lucid as'program' for \
    from'gh-r' pick"$gh_pick" \
    atclone'cp -vf **/*.1 "${ZPFX}/share/man/man1"' \
    atpull'%atclone' \
    '@cli/cli' \
    \
    from'gh-r' \
    'zaquestion/lab' \
    \
    'davidosomething/git-ink' \
    'davidosomething/git-my' \
    'davidosomething/git-relevant' \
    'davidosomething/git-take' \
    \
    'paulirish/git-recent' \
    \
    pick"${ZPFX}/bin/git-*" \
    src'etc/git-extras-completion.zsh' \
    make"PREFIX=${ZPFX}" \
    'tj/git-extras' \
    ;

  # ----------------------------------------------------------------------------

  zinit lucid for \
    if'! __dko_has fzf' from'gh-r' as'program' 'junegunn/fzf-bin' \
    'torifat/npms' \
    ;

  # my fork of cdbk, ZSH hash based directory bookmarking. No wait!
  export ZSH_BOOKMARKS="${HOME}/.local/zshbookmarks"
  zinit lucid light-mode for 'davidosomething/cdbk'

  export _ZO_DATA="${XDG_DATA_HOME}/zoxide"

  # Customized from instructions at https://github.com/sharkdp/bat#man
  local bat_manpager="export MANPAGER=\"sh -c 'col -bx | bat --language man --paging always --style=grid'\""
  local delta_gitpager="export GIT_PAGER='delta --dark'"

  zinit lucid from'gh-r' as'program' for \
    mv'bat* -> bat' \
    pick'bat/bat' \
    atclone'cp -vf bat/bat.1 "${ZPFX}/share/man/man1"; cp -vf bat/autocomplete/bat.zsh "bat/autocomplete/_bat"' \
    atpull'%atclone' \
    atload"$bat_manpager" \
    '@sharkdp/bat' \
    \
    mv'delta* -> delta' \
    pick'delta/delta' \
    atload"$delta_gitpager" \
    'dandavison/delta' \
    \
    mv'fd* -> fd' pick'fd/fd' \
    atclone'cp -vf fd/fd.1 "${ZPFX}/share/man/man1"' \
    atpull'%atclone' \
    '@sharkdp/fd' \
    \
    mv'jq* -> jq'             'stedolan/jq' \
    mv'nvim-ctrl* -> nvctl'   'chmln/nvim-ctrl'   \
    mv'shfmt* -> shfmt'       '@mvdan/sh'         \
    \
    mv'zoxide* -> zoxide' \
    atclone'chmod +x zoxide' \
    atpull'%atclone' \
    atload'eval "$(zoxide init --no-aliases zsh)" && alias j=__zoxide_z' \
    'ajeetdsouza/zoxide' \
    \
    mv'ripgrep* -> rg' pick'rg/rg' \
    atclone'cp -vf rg/doc/rg.1 "${ZPFX}/share/man/man1"' \
    atpull'%atclone' \
    'BurntSushi/ripgrep' \
    ;

  zinit snippet 'OMZP::cp'
  zinit snippet 'OMZP::extract'

  # ----------------------------------------------------------------------------
  # Completion
  # ----------------------------------------------------------------------------

  # In-line best history match suggestion
  # don't suggest lines longer than
  export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=78
  # as of v4.0 use ZSH/zpty module to async retrieve
  export ZSH_AUTOSUGGEST_USE_ASYNC=1
  # Removed forward-char
  export ZSH_AUTOSUGGEST_ACCEPT_WIDGETS=(vi-end-of-line)
  export ZSH_AUTOSUGGEST_STRATEGY=(history completion)
  export ZSH_AUTOSUGGEST_MANUAL_REBIND=1

  zinit lucid wait for \
    if'[[ -f "${TRAVIS_CONFIG_PATH}/travis.sh" ]] ' \
    "$TRAVIS_CONFIG_PATH" \
    \
    atload'_zsh_autosuggest_start && bindkey "^n" autosuggest-accept' \
    'zsh-users/zsh-autosuggestions' \
    \
    blockf atpull'zinit creinstall -q .' \
    'zsh-users/zsh-completions' \
    ;

  # ----------------------------------------------------------------------------
  # Syntax last, and compinit before it
  # ----------------------------------------------------------------------------

  # don't add wait, messes with zsh-autosuggest
  zinit lucid atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" for \
    'zdharma/fast-syntax-highlighting'
}

# file does not exist on busybox
command -v file >/dev/null && __load_zinit_plugins

DKO_SOURCE="${DKO_SOURCE} }"
