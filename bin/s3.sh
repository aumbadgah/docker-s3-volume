#!/bin/bash

ProgName=$(basename $0)

LOCAL=${LOCAL:-"/data"}

SYNC_FORCE_RESTORE=false
SYNC_PUSH_ONLY=false
SYNC_CLEAN_LOCAL=false

PULL_DELETE=false
PUSH_DELETE=false

if [ "$ENDPOINT_URL" ]; then
  AWS="aws --endpoint-url $ENDPOINT_URL"
else
  AWS=aws
fi

usage(){
cat <<-EOF
  Usage:"
      s3 -h                      Display this help message.
  #     s3 sync <local> <remote>   Sync <local> with s3 <remote>.
      s3 pull <local> <remote>   Pull from s3 <remote> to <local>.
      s3 push <local> <remote>   Push from <local> to s3 <remote>.
EOF
  exit 0
}

sync(){
    echo "Sync $LOCAL => $REMOTE"
}

function pull {
  pull_args=""

  if [[ $PULL_DELETE == 'true' ]]; then
    pull_args="$pull_args --delete"
  fi

  cmd="$AWS s3 sync $REMOTE $LOCAL $pull_args"
  echo $cmd
  $cmd
}

function push {
  push_args=""

  if [[ $PUSH_DELETE == 'true' ]]; then
    push_args="$push_args --delete"
  fi

  cmd="$AWS s3 sync $LOCAL $REMOTE $push_args"
  echo $cmd
  $cmd
}

while getopts ":h" opt; do
  case ${opt} in
    h )
      usage
      ;;
    * )
      usage
      exit 1
      ;;
  esac
done
shift $((OPTIND -1))

subcommand=$1; shift
if [ -z "$subcommand" ]; then
  usage
fi
case "$subcommand" in
  # sync)
  #   while getopts ":hfpc" opt; do
  #     case ${opt} in
  #       h )
  #         echo "Usage:"
  #         echo "    s3 sync [options] [<local> [<remote>]]"
  #         echo "    s3 sync [options] /data s3://my-bucket"
  #         echo
  #         echo "    -h    Display this help message."
  #         echo "    -f    Force restore. Ignore existing local files and pull from s3 to local"
  #         echo "    -p    Push only. No longer restores from s3 to local."
  #         echo "          No longer pushes with --delete"
  #         echo "    -c    Clean local files. Removes local files after push."
  #         echo "          Requires \"-p\" \"push only\" to have effect. "
  #         echo
  #         echo "Example:"
  #         echo "    s3 sync -f /data s3://my-bucket"
  #         exit 0
  #         ;;
  #       f )
  #         SYNC_FORCE_RESTORE=true
  #         ;;
  #       p )
  #         SYNC_PUSH_ONLY=true
  #         ;;
  #       c )
  #         SYNC_CLEAN_LOCAL=true
  #         ;;
  #       \? )
  #         echo "Invalid Option: -$OPTARG" 1>&2
  #         exit 1
  #         ;;
  #     esac
  #   done
  #   shift $((OPTIND -1))

  #   LOCAL=${1:-$LOCAL}; shift
  #   REMOTE=${1:-$REMOTE}; shift

  #   sync
  #   ;;
  pull)
    while getopts ":hd" opt; do
      case ${opt} in
        h )
cat <<-EOF
  Usage:"
      s3 pull <local> <remote>

      -h    Display this help message.
      -d    Pull files from remote with --delete flag on.
EOF
          exit 0
          ;;
        d )
          PULL_DELETE="true"
          ;;
        \? )
          echo "Invalid Option: -$OPTARG" 1>&2
          ;;
      esac
    done
    shift $((OPTIND -1))

    echo "${@:2}"

    LOCAL=${1:-$LOCAL}; shift
    REMOTE=${1:-$REMOTE}; shift

    pull
    ;;
  push)
    while getopts ":hd" opt; do
      case ${opt} in
        h )
cat <<-EOF
  Usage:"
      s3 push <local> <remote>

      -h    Display this help message.
      -d    Push files from local to s3 with --delete flag on.
EOF
          exit 0
          ;;
        d )
          PUSH_DELETE="true"
          ;;
        \? )
          echo "Invalid Option: -$OPTARG" 1>&2
          exit 1
          ;;
      esac
    done
    shift $((OPTIND -1))

    LOCAL=${1:-$LOCAL}; shift
    REMOTE=${1:-$REMOTE}; shift

    push
    ;;
esac
