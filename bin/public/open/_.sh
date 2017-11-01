

source "$THIS_DIR/bin/public/cache/_.sh"
source "$THIS_DIR/bin/public/edit/_.sh"
source "$THIS_DIR/bin/public/choose/_.sh"

# === {{CMD}}  some/dir/
# === {{CMD}}  some/dir/file.txt
# === {{CMD}}  --choose [last|file|dir|..]

open () {
  case "$@" in

    "--choose "*)
      shift
      local +x FS="$(choose $@ || :)"
      if [[ -z "$FS" ]]; then
        return 0
      fi

      open "$FS"
      ;;

    */)
      local +x DIR="$1"
      if [[ ! -d "$(realpath -m "$DIR")" ]]; then
        echo "!!! Is not a directory: $DIR" >&2
        exit 2
      fi

      edit "$DIR"/
      ;;


    *) # === Open file:
      local +x FS="$1"; shift
      local +x REAL="$(realpath -m "$FS")"
      if [[ ! -e "$REAL" ]]; then
        echo "!!! Does not exist: $FS" >&2
        exit 2
      fi

      edit "$FS"
      ;;

  esac # === $COMMAND $@

} # === end function
