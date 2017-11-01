
source "$THIS_DIR/bin/public/cache/_.sh"

# === {{CMD}}  file|dir
edit () {
  local +x FS="$1"; shift
  if [[ ! -e "$FS" ]]; then
    echo "!!! Does not exist: $FS" >&2
    exit 1
  fi

  local +x FIN="$(echo "$FS" | tr -s '/')"
  if [[ "$FS" != */ && -d "$FS" ]]; then
    FIN="$FS/"
  fi

  cache insert "$FIN"
  $EDITOR "$FS"
  cache insert "$FIN"

} # === end function
