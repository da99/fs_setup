#
# === {{CMD}} dirs [args to append to find]
#

empty () {
  local +x ACTION=$1; shift
  case "$ACTION" in
    dirs)
      IFS=$'\n'
      for dir in $(my_fs ls-dirs) ; do
        find $dir -type d -empty $@
      done
      ;;
    *)
      ;;
  esac
} # empty ()
