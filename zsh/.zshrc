
plugins=(
git 
zsh-autosuggestions 
zsh-syntax-highlighting
fzf-tab
)

eval "$(fnm env)"

# === jmp: 키 → 경로 맵 기반 이동 ===
# 키와 대상 경로를 여기에 등록하세요.
typeset -A JMP_MAP=(
  workspace    "$HOME/workspace"
  fe-ccp    "$HOME/workspace/ccp/fe-ccp"
  be-ccp    "$HOME/workspace/ccp/be-ccp"
  ccp:main    "$HOME/workspace/ccp/fe-ccp/apps/main"
  ccp:bff    "$HOME/workspace/ccp/fe-ccp/apps/bff"
  ccp:components    "$HOME/workspace/ccp/fe-ccp/packages/components/react"

  etc      "$HOME/workspace/etc"
  img      "$HOME/workspace/etc/ImagePathifier"
  study    "$HOME/workspace/etc/book-study-for-developers"
  # 예시:
  # work  "$HOME/work"
  # logs  "$HOME/logs"
)

# 메인 명령
jmp() {
  local key="$1"
  local dest=""

  # 도움말
  if [[ -z "$key" || "$key" == "-h" || "$key" == "--help" ]]; then
    echo "사용법: jmp <키>"
    echo "등록된 키: ${(k)JMP_MAP}"
    echo "키 추가:  JMP_MAP[이름]=\"/원하는/경로\"  (추가 후 'source ~/.zshrc')"
    return 0
  fi

  dest="${JMP_MAP[$key]}"

  if [[ -z "$dest" ]]; then
    echo "알 수 없는 키: $key"
    echo "등록된 키: ${(k)JMP_MAP}"
    return 1
  fi

  if [[ -d "$dest" ]]; then
    builtin cd "$dest"
  else
    echo "경로가 존재하지 않습니다: $dest"
    return 1
  fi
}

# 자동완성: 등록된 키 제안
_jmp() {
  if (( CURRENT == 2 )); then
    compadd -- ${(k)JMP_MAP}
  fi
}

compdef _jmp jmp
