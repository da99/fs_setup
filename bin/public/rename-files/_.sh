
# === {{CMD}}  partial-to-remove
# === "cd" into a directory and remove a partial substring from each filename.
rename-files () {
  local +x PARTIAL="$@"
  local +x IFS=$'\n'
  for FILE in $(find . -mindepth 1 -maxdepth 1 -type f); do
    mv -i "$FILE" "${FILE/"$PARTIAL"/}"
  done
} # === end function
