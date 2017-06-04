
# === {{CMD}}  source(old)  dest(new)
link () {
  PATH="$PATH:$THIS_DIR/../sh_color/bin"
  local +x orig=$1
  local +x target=$2

  local +x CMD="ln -s"
  if [[ "$(stat -c %U "$(dirname "$target")" )" != "$USER" ]]; then
    CMD="sudo $CMD"
  fi

  # IF broken link exists, remove
  if [[ -h "$target" && ! -e "$(readlink $target)" ]]; then
    echo -e "\n!!! trashing broken link: $target\n"
    trash-put $target
  fi

  # --- IF it does NOT exit?
  if [[ ! -e "$target" ]]
  then # --- create link
    echo "=== Running: $CMD $orig $target" >&2
    $CMD $orig $target
    sh_color GREEN "--- Linked: $orig {{$target}}"
  else

    # --- IF is a sym link?
    if [[ -h "$target" && "$(readlink -f "$target")" == "$(readlink -f $orig)" ]]
    then
      echo "Already sym link: $target"

    else
      sh_color RED -e "\n=== Check existing object: {{$target}}"
      echo -e "\n diff $orig $target\n\n" 1>&2
      exit 1

    fi # --- valid sym link?
  fi # --- ! -e
} # === end function
