
# === {{CMD}}  list of files ...
# === Interactive programs: asks you what to rename each file to.
rename-files () {
  while [[ ! -z "$@" ]]; do
    local +x FILE="$1"; shift
    local +x REAL_FILE="$(realpath "$FILE")"
    local +x REAL_DIR="$(dirname "$REAL_FILE")"
    echo -n "Change $REAL_FILE to new file name: "
    read -r NEW_NAME
    echo -n "Confirm (y/n): $REAL_FILE -> $REAL_DIR/$NEW_NAME : "
    read -r ANS
    local +x -l ANS="$ANS"

    case "$ANS" in
      y|yes)
        mv -i "$REAL_FILE" "$REAL_DIR"/"$NEW_NAME"
        ;;
      *)
        continue
        ;;
    esac
  done
} # === end function
