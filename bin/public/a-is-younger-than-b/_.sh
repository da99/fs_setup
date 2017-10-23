#
# === {{CMD}} file-a file-b
# === Uses the modified time to compare age.
#

a-is-younger-than-b () {
  local +x A="$1"
  local +x B="$1"

  if [[ ! -f "$A" || ! -f "$B" ]]; then
    return 1
  fi

  local +x A_MOD="$(stat --format="%Y" "$A")"
  local +x B_MOD="$(stat --format="%Y" "$B")"

  [[ "$A_MOD" -gt "$B_MOD" ]]
} # a-is-younger-than-b ()
