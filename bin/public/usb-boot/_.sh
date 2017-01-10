
# === {{CMD}}  file
# === Finds device, formats it, and writes file to it.

# From: https://www.digitalocean.com/community/tutorials/how-to-partition-and-format-storage-devices-in-linux
usb-boot () {
  # sudo fdisk -l
  local +x ISO="$1"; shift
  if [[ ! -e "$FILE" ]]; then
    echo "!!! Not a file: $FILE"
  fi

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

  local +x SIZE="$(echo "$SIZE_NAME" | cut -d' ' -f1)"
  local +x NAME="$(echo "$SIZE_NAME" | cut -d' ' -f2)"
  echo "Found:"
  echo "  SIZE:  $SIZE"
  echo "  NAME:  $NAME"
  echo "  Label: $(ls -l /dev/disk/by-label | grep "$NAME" | cut -d' ' -f9)"

  echo "Is this corrent? (y/N):"
  read ans
  echo -n "Please wait."; sleep 1
  echo -n '.'; sleep 1; echo -n '.'; sleep 1
  echo -n '.'; sleep 1; echo -n '.'; sleep 1
  echo '.'; sleep 1

  case "$ans" in
    y|Y|YES|yes)
      set "-x"
      sudo parted /dev/$NAME mklabel gpt
      sudo parted -a opt /dev/$NAME mkpart primary ext4 0% 100%
      set +x
      echo "=== Results:"
      lsblk | grep "$NAME"

      echo "=== Creating filesystem on partion ${NAME}1 on disk $NAME:"
      sudo mkfs.ext4 -L usbboot /dev/${NAME}1
      echo "=== Results:"
      lsblk --fs | grep "$NAME"

      echo "=== Writing file to disk: $FILE"
      sudo dd bs=4M if="$FILE" of=/dev/$NAME status=progress && sync
      ;;
    *)
      echo "Exiting..."
      exit 1
      ;;
  esac
} # === end function
