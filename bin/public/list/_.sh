#
# === {{CMD}} empty dirs
#

list () {
  case "$(echo $@)" in
    "empty dirs")
      shift; shift
      IFS=$'\n'
      for dir in $(my_fs ls-dirs) ; do
        find $dir -type d -empty
      done
      ;;
    *)
      echo "!!! Unknown arguments: list $@" >&2
      exit 5
      ;;
  esac
} # list ()
