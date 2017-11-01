
source "$THIS_DIR/bin/public/cache/_.sh"
source "$THIS_DIR/bin/public/edit/_.sh"
source "$THIS_DIR/bin/public/choose/_.sh"

# === {{CMD}}  some/dir/
# === {{CMD}}  some/dir/file.txt
# === {{CMD}}  --choose [last|file|dir|...]
create () {
  local +x CMD="$1"; shift

  case "$CMD" in

    --choose)
      local +x FS="$(choose $@ || :)"
      if [[ -z "$FS" ]]; then
        return 0
      fi

      create "$FS"
      ;;

    */)
      local +x DIR="$CMD"
      local +x REAL="$(realpath -m "$DIR")"

      if [[ -e "$REAL" ]]; then
        echo "!!! Already exists: $DIR" >&2
        exit 2
      fi

      mkdir -p "$DIR"
      echo "=== Created: $DIR" >&2
      ;;

    *) # === Create file:
      local +x FS="$CMD"
      local +x REAL="$(realpath -m "$FS")"
      if [[ -e "$REAL" ]]; then
        echo "!!! Already exists: $FS" >&2
        exit 2
      fi

      if [[ "$FS" == */ ]]; then
        create "$FS"
      else
        mkdir -p "$(dirname "$REAL")"
        touch "$REAL"
        edit "$FS"
      fi
      ;;

  esac # === $COMMAND $@

} # === end function
