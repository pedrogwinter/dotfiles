# =======================================================
# ZSH CONFIGURAÇÃO: SHELDON POWER SIDE (OPTIMIZED)
# =======================================================

# --- 1. POWERLEVEL10K INSTANT PROMPT ---
# Deve ficar no topo para garantir que o terminal abra instantaneamente
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# --- 2. PATH E AMBIENTE ---
export PATH="$HOME/.local/bin:$PATH"
export EDITOR="micro"
export VISUAL="micro"

# --- 3. INICIALIZAÇÃO DO SHELDON ---
# Carrega os plugins do ~/.config/sheldon/plugins.toml
eval "$(sheldon source)"

# --- 4. CONFIGURAÇÕES DE HISTÓRICO E UI ---
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history

setopt share_history      # Compartilha histórico entre abas
setopt append_history     # Adiciona ao histórico imediatamente
setopt extended_history   # Salva timestamp no histórico
setopt correct            # Sugere correção de erros de digitação
setopt autocd             # Digitar o nome da pasta entra nela
setopt auto_name_dirs     # Trata nomes de variáveis como caminhos

# Ativa o sistema de autocompletar moderno
autoload -Uz compinit
compinit

# --- 5. FUNÇÕES CUSTOMIZADAS (Substituindo Plugins do OMZ) ---

# Sudo (Esc Esc)
sudo-command-line() {
    [[ -z $BUFFER ]] && zle up-history
    if [[ $BUFFER == sudo\ * ]]; then
        LBUFFER="${LBUFFER#sudo }"
    else
        LBUFFER="sudo $LBUFFER"
    fi
}
zle -N sudo-command-line
bindkey "\e\e" sudo-command-line

# Extract Ultra-Universal v3.0
extract() {
  if [ -f "$1" ] ; then
    case "$1" in
      *.tar.bz2)   tar xvf "$1"        ;;
      *.tar.gz)    tar xvf "$1"        ;;
      *.tar.xz)    tar xvf "$1"        ;;
      *.tar.zst)   tar --zstd -xvf "$1" ;;
      *.bz2)       bunzip2 "$1"        ;;
      *.rar)       unrar x "$1"        ;;
      *.gz)        gunzip "$1"         ;;
      *.tar)       tar xvf "$1"        ;;
      *.tbz2)      tar xvf "$1"        ;;
      *.tgz)       tar xvf "$1"        ;;
      *.zip)       unzip "$1"          ;;
      *.Z)         uncompress "$1"     ;;
      *.7z)        7z x "$1"           ;;
      *.xz)        unxz "$1"           ;;
      *.exe)       7z x "$1"           ;;
      *.zst)       unzstd "$1"         ;;
      *.dmg|*.pkg) 7z x "$1"           ;;
      *.iso)       7z x "$1"           ;;
      *.cab)       7z x "$1"           ;;
      *.rpm)       rpm2cpio "$1" | cpio -idmv ;;
      *.deb)       7z x "$1" && 7z x data.tar ;;
      *.jar|*.war|*.ear|*.apk) unzip "$1" ;;
      *)           echo "'$1' não pode ser extraído via extract()" ;;
    esac
  else
    echo "'$1' não é um arquivo válido"
  fi
}

# --- 6. ALIASES ---

# IA (OpenAI & Gemini)
alias ai='sgpt --code --model gpt-4o'
alias aiexec='sgpt --execute'
alias gem='gemini'
alias aicode='gemini -m gemini-2.5-flash -c "me dê apenas o código para a pergunta a seguir:"' 

# Sistema
alias c='clear'
alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -iv'
alias mkdir='mkdir -pv'
alias df='df -h'
alias du='du -h'
alias p='ps aux'
alias history='history 1'

# Navegação e Listagem
alias m='micro'
alias l='ls -lh --color=auto'
alias la='ls -lha --color=auto'
alias ll='ls -l --color=auto'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# DNF
alias d='sudo dnf'
alias install='sudo dnf install'
alias update='sudo dnf update'
alias clean='sudo dnf autoremove && sudo dnf clean all'
alias findpkg='sudo dnf search'

# Git
alias gpull='git pull --rebase'
alias glog='git log --oneline --decorate --all --graph'
alias gco='git checkout'
alias gcb='git checkout -b'

# Configuração
alias zshconfig='micro ~/.zshrc'
alias zshreload='source ~/.zshrc'

# Midia
alias ytmp3='yt-dlp -x --audio-format mp3'

# --- 7. ATALHOS GUI (ZLE - Mapeamentos de Teclas) ---

select-all() {
  zle beginning-of-line
  zle set-mark-command
  zle end-of-line
}
zle -N select-all
bindkey '^Xa' select-all 

bindkey '^[[3~' delete-char       
bindkey '^H' backward-kill-word   
bindkey '^[[3;5~' kill-word       
bindkey '^Z' undo                 

bindkey '^[[1;5D' backward-word   
bindkey '^[[1;5C' forward-word    
bindkey '^[[H' beginning-of-line  
bindkey '^[[F' end-of-line        
bindkey '^[[1;5A' beginning-of-line 
bindkey '^[[1;5B' end-of-line       

bindkey '^[[5~' history-beginning-search  
bindkey '^[[6~' history-end-search        

bindkey '\C- ' set-mark-command 

bindkey '^[[1;2D' backward-char  
bindkey '^[[1;2C' forward-char   
bindkey '^[[1;2H' beginning-of-line 
bindkey '^[[1;2F' end-of-line       

bindkey '^[[1;6D' backward-word  
bindkey '^[[1;6C' forward-word   

bindkey '^[[1;6A' beginning-of-line 
bindkey '^[[1;6B' end-of-line       

# --- 8. POWERLEVEL10K THEME ---
# Carrega o tema por último
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
