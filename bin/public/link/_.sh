
# === {{CMD}}  source(old)  dest(new)
# === `ln -s` does not resolve source destinations.
# === For example: config/file -> dir/file -> (non-existant) dir/config/file
# === This function resolves the source before linking.
# === It does not resolve the DEST because DEST can already exist and point
# === to a non-existing location, which would be captured by a resolve.
link () {
  PATH="$PATH:$THIS_DIR/../sh_color/bin"
  local +x ORIG="$(realpath --canonicalize-existing "$1")"
  local +x DEST="$2"
  local +x REAL_DEST="$(realpath --canonicalize-existing "$DEST")"

  if [[ -z "$ORIG" || -z "$DEST" ]]; then
    exit 2
  fi

  if [[ -d "$DEST" ]]; then
    DEST="$DEST/$(basename "$ORIG")"
  fi

  # === Check if it already exists:
  if [[ "$ORIG" == "$REAL_DEST" ||  "$ORIG" == "$(realpath --canonicalize-missing "$DEST")" ]]; then
    echo "=== Already linked:" >&2
    echo "$ORIG -> $DEST" >&2
    return 0
  fi

  if [[ -h "$DEST"  && ! -e "$DEST" ]]; then
    echo "!!! Link exists, but is broken: " >&2
    echo "$DEST -> "$(realpath --canonicalize-missing "$DEST")""
    exit 2
  fi

  local +x CMD="ln -s"
  if [[ "$(stat -c %U "$(dirname "$DEST")" )" != "$USER" && ! -w "$(dirname "$DEST")" ]]; then
    CMD="sudo $CMD"
  fi

  # --- IF it does NOT exit?
  echo "=== Running: $CMD $ORIG $DEST" >&2
  $CMD "$ORIG" "$DEST"
  sh_color GREEN "--- Linked: $ORIG {{$DEST}}"

} # === end function


# NOTES: for specs
# ln -s file  dir/
# ln -s file  dir/existing/realpath/file
# ln -s file  dir/linked/file/file
# ln -s dir1/ dir2/



