
source "$THIS_DIR"/bin/public/modified-age/_.sh

# === {{CMD}}  SECONDS  filename
is-older-than () {
  local +x SECONDS="$1"; shift
  local +x FILENAME="$1"; shift

  if [[ ! -e "$FILENAME" ]]; then
    return 0
  fi

  local +x AGE="$(modified-age "$FILENAME")"

  [[ "$AGE" -gt "$SECONDS" ]]
} # === end function
