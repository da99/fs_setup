
# === {{CMD}}  source(old)  dest(new)
link () {
  PATH="$PATH:$THIS_DIR/../sh_color/bin"
  local +x orig=$1
  local +x target=$2

  local +x REAL_ORIG="$(realpath "$orig")"
  local +x REAL_TARGET="$(realpath "$target")"

  if [[ -d "$REAL_TARGET" ]]; then
    local +x REAL_TARGET_DIR="$REAL_TARGET"
  else
    local +x REAL_TARGET_DIR="$(dirname "$REAL_TARGET")"
  fi

  # Is this a file being linked to a directory?:
  #   ln -s file dir/
  if [[ -f "$REAL_ORIG" && -d "$REAL_TARGET"  && "$REAL_TARGET" == "$REAL_TARGET_DIR" ]]; then
    REAL_TARGET="$REAL_TARGET/$(basename "$REAL_ORIG")"
  fi

  local +x CMD="ln -s"
  if [[ "$(stat -c %U "$REAL_TARGET_DIR" )" != "$USER" ]]; then
    CMD="sudo $CMD"
  fi

  # IF broken link exists, remove
  if [[ -h "$target" && ! -e "$REAL_TARGET" ]]; then
    echo -e "\n!!! trashing broken link: $target\n"
    trash-put $target
  fi

  # --- IF it does NOT exit?
  if [[ ! -e "$REAL_TARGET" ]] ; then # --- create link
    echo "=== Running: $CMD $orig $target" >&2
    $CMD $orig $target
    sh_color GREEN "--- Linked: $orig {{$target}}"
  else

    # --- IF is a sym link?
    if [[ "$(realpath "$REAL_TARGET")" == "$REAL_ORIG" ]]; then
      echo "Already sym link: $target"

    else
      sh_color RED -e "\n=== Check existing object: {{$target}}"
      echo -e "\n diff $orig $target\n\n" 1>&2
      exit 1
    fi # --- valid sym link?
  fi # --- ! -e
} # === end function


# NOTES: for specs
# ln -s file  dir/
# ln -s file  dir/existing/realpath/file
# ln -s file  dir/linked/file/file
# ln -s dir1/ dir2/



