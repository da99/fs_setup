
source "$THIS_DIR/bin/public/history/_.sh"
source "$THIS_DIR/bin/public/edit/_.sh"
# === {{CMD}}  new       new/dir/file.txt
# === {{CMD}}  new       new/dir/
new () {
  local +x FS="$1"; shift

  case "$FS" in
    */)
      mkdir -p "$FS"
      history insert "$FS"
      ;;

    *)
      local +x DIR="$(dirname "$FS")"
      mkdir -p "$DIR"
      touch "$FS"
      edit "$FS"
      ;;
  esac
} # === end function
