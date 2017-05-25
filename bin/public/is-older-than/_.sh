
source "$THIS_DIR"/bin/public/modified-age/_.sh

# === {{CMD}}  SECONDS  filename
# === Exits with 1 if file is old or does not exist.
is-older-than () {
  local +x SECONDS="$1"; shift
  local +x FILENAME="$1"; shift

  if [[ ! -e "$FILENAME" ]]; then
    return 1
  fi

  local +x NOW="$(date +"%s")"
  local +x THEN="$(stat -c %Y "$FILENAME")"
  local +x AGE="$(( NOW - THEN ))"

  [[ "$AGE" -gt "$SECONDS" ]]
} # === end function
