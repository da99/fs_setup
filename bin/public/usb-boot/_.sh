
# === {{CMD}}  file
# === Finds device, formats it, and writes file to it.

# From: https://www.digitalocean.com/community/tutorials/how-to-partition-and-format-storage-devices-in-linux
usb-boot () {
  # sudo fdisk -l
  local +x IFS=$'\n'
  local +x SIZE_NAME="$(for LINE in $(lsblk -l | tr -s ' '); do
    local +x MOUNT_POINT="$(echo "$LINE" | cut -d' ' -f6)"
    local +x NAME="$(echo "$LINE" | cut -d' ' -f1)"
    local +x SIZE="$(echo "$LINE" | cut -d' ' -f4)"
    if [[ "$MOUNT_POINT" == "disk" ]]; then
      echo "$SIZE" "$NAME"
    fi
  done | sort -h | head -n 1)"
  if [[ -z "$SIZE_NAME" ]]; then
    echo "!!! No drive found." >&2
    exit 1
  fi

  local +x NAME="$(echo "$SIZE_NAME" | cut -d' ' -f2)"
  echo -n "Is this corrent? (y/N): $SIZE_NAME ($(ls -l /dev/disk/by-label | grep "$NAME" | cut -d' ' -f10)) : "

  read ans
  case "$ans" in
    y|Y|YES|yes)
      echo "== done: $NAME"
      ;;
    *)
      echo "Exiting..."
      exit 1
      ;;
  esac
} # === end function
