
source "$THIS_DIR"/bin/public/modified-age/_.sh

# === {{CMD}}  SECS  path/to/file
# === Exits with 1 if file is older.
# === Exits with 0 if file is young or does not exist.
# === Easier to reason if you combine it with: `test -e "filename"`
is-younger-than () {
  local +x SECONDS="$1"; shift
  local +x FILENAME="$1"; shift

  if [[ ! -e "$FILENAME" ]]; then
    return 0
  fi

  local +x NOW="$(date +"%s")"
  local +x THEN="$(stat -c %Y "$FILENAME")"
  local +x AGE="$(( NOW - THEN ))"

  [[ "$AGE" -lt "$SECONDS" ]]
} # === end function