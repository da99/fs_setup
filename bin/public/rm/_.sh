#
# === {{CMD}} empty dirs
#

rm () {
  unset -f rm
  case "$(echo $@)" in
    "empty dirs")
      shift; shift
      IFS=$'\n'
      for dir in $(my_fs list empty dirs); do
        rm -r --verbose $dir
      done
      ;;

    *)
      echo "!!! Unknown arguments: rm $@" >&2
      exit 5
      ;;
  esac

} # rm ()
