
# === {{CMD}}  min-cpu  seconds
# === Lists processes running for more than "seconds"
# === higher than "min-cpu": {{CMD}} 90 5
top-cpu () {
  local +x NOW="$(date +"%s")"
  local +x MIN_CPU="$1"; shift
  local +x SECONDS="$1"; shift

  local +x IFS=$'\n'
  local +x CACHE="$THIS_DIR"/tmp/top-cpu
  mkdir -p "$CACHE"
  local +x RECORD="$CACHE"/record.txt
  local +x PREV="$CACHE"/prev.txt

  delete-if-old "$SECONDS" "$NOW" "$RECORD"
  delete-if-old "$SECONDS" "$NOW" "$PREV"

  local +x COUNT="1"

  # IF max has been reached, reset.
  if [[ -f "$CACHE/${SECONDS}.txt" ]]; then
    rm -f "$CACHE"/*.txt
  fi

  # FIND next iteration:
  while [[ "$COUNT" -lt "$SECONDS" ]]; do
    if [[ ! -f "$CACHE/${COUNT}.txt" ]]; then
      break
    fi
    COUNT="$((COUNT + 1))"
  done

  local +x CONTENT=""
  for LINE in $(ps aux --no-headers | sort -nrk 3,3 | tr -s ' ' | head -n 10 | cut -d' ' -f2,3,11); do
    IFS=$' '
    set $LINE
    IFS=$'\n'

    local +x PID=$1
    local +x CPU=$2
    local +x CMD=$3
    if [[ ! "${CPU%.*}" -gt "$MIN_CPU" ]]; then
      continue
    fi

    if [[ -z "$CONTENT" ]]; then
      CONTENT+="$CMD"
    else
      CONTENT+="\n$CMD"
    fi
  done

  echo -e "$CONTENT" | sort | uniq > "$CACHE/${COUNT}.txt"
  cat "$CACHE"/*.txt | sort | uniq -c
} # === end function

delete-if-old () {
  local +x MIN="$1"; shift
  local +x NOW="$1"; shift
  local +x FILE="$1"; shift
  if [[ ! -e "$FILE" ]]; then
    return 0
  fi
  local +x AGE="$(stat --format="%Y")"
  if [[ "$(( NOW - AGE ))" -gt "$MIN" ]]; then
    rm -f "$FILE"
  fi
} # delete-if-old
