
source "$THIS_DIR/bin/public/cache/_.sh"

# === {{CMD}}  last  # === Choose from last line in cache.
# === {{CMD}}  file  # === Fuzzy search the cache.
# === {{CMD}}  dir   # === Fuzzy search the cache for directories.
# === {{CMD}}  bin   # === Fuzzy search bin files.
choose () {
  local +x CMD="$1"; shift
  local +x PROMPT=">> "

  case "$CMD" in
    function)
      set +o pipefail
      local +x FS="$(find -L bin/private bin/public -mindepth 1 -maxdepth 1 -type d 2>/dev/null | fzy)"
      if [[ ! -z "$FS" ]]; then
        if [[ -d "$FS" && -e "$FS/_.sh" ]]; then
          FS="$FS/_.sh"
        fi
        bash -c "read -e -i '$FS' -p '$PROMPT' DIR; echo \$DIR;"
      fi
      ;;

    project-file)
      if [[ ! -d ".git" ]]; then
        echo "!!! Not a git repo: $PWD"
        exit 2
      fi

      local +x FS="$(
        set +o pipefail
        if [[ -d .git ]]; then
          git ls-files --others --modified  --cached | sort --human-numeric-sort | uniq | fzy
        else
          ls -1 -A | sort --human-numeric-sort | uniq | fzy
        fi
      )"

      if [[ -z "$FS" ]]; then
        exit 2
      fi

      bash -c "read -e -i '$FS' -p '$PROMPT' FILE; echo \$FILE;"
      ;;

    project-dir)
      if [[ ! -d ".git" ]]; then
        echo "!!! Not a git repo: $PWD"
        exit 2
      fi

      local +x FS="$(
        set +o pipefail
        git ls-files --others --modified  --cached | xargs -I NAME dirname "NAME" | awk '!seen[$0]++' | grep -v -E '^\.$' | xargs -I NAME echo "NAME"/ | fzy
      )"

      if [[ -z "$FS" ]]; then
        exit 2
      fi

      bash -c "read -e -i '$FS' -p '$PROMPT' FILE; echo \$FILE;"
      ;;

    last)
      local +x FS="$(cache last)"
      if [[ -z "$FS" ]]; then
        echo "=== No file/dir found." >&2
        exit 2
      fi

      bash -c "read -e -i '$FS' -p '$PROMPT' FILE; echo \$FILE;"
      ;;

    file)
      local +x FILE="$(ls -1 -A | tac | (fzy || :))"

      if [[ -z "$FILE" ]]; then
        return 0
      fi

      bash -c "read -e -i '$FILE' -p '$PROMPT' FILE; [[ ! -z \"\$FILE\" ]] && echo \$FILE;"
      ;;

    dir)
      local +x LIST="$(cache list-dirs)"
      if [[ -z "$LIST" ]]; then
        echo "> [No directorys found.]" >&2
        local +x FS="./"
      else
        local +x FS="$(echo "$LIST" | (fzy || :))"
      fi

      if [[ -z "$FS" ]]; then
        return 0
      fi

      bash -c "read -e -i '$FS' -p '$PROMPT' FS; [[ ! -z \"\$FS\" ]] && echo \$FS;"
      ;;

    *)
      echo "!!! Invalid command: $CMD $@" >&2
      exit 1
      ;;
  esac
} # === end function
