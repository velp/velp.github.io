#!/bin/bash

set -e
# set -x
set -o pipefail

ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S %z')

POSITIONAL_ARGS=()
while [[ $# -gt 0 ]]; do
  case $1 in
    -t|--title)
      TITLE="$2"
      shift # past argument
      shift # past value
      ;;
    -*|--*)
      echo "Unknown option $1"
      exit 1
      ;;
    *)
      POSITIONAL_ARGS+=("$1") # save positional arg
      shift # past argument
      ;;
  esac
done

set -- "${POSITIONAL_ARGS[@]}" # restore positional parameters

if [[ -z $TITLE ]]; then
    echo "-t | --title artgument required"
    exit 1
fi

IFS=
template="$(cat <<-EOF
---
title: $TITLE
date: $TIMESTAMP
categories: [TOP_CATEGORIE, SUB_CATEGORIE]
## TAG names should always be lowercase
tags: [TAG]
## Pin pos to the top of the home page
pin: false
## Preview image
# image: /path/to/image
## Enable mermind
mermaid: false
## Enable mathematical feature
math: false
## Enable/disable comments
comments: false
## Table of contants
toc: true
## Other functionality: https://chirpy.cotes.page/posts/write-a-new-post/
---

# Header 1

> This is an example of a Tip.
{: .prompt-tip }

> This is an example of an Info block.
{: .prompt-info }

> This is an example of a Warning block.
{: .prompt-warning }

> This is an example of a Danger block.
{: .prompt-danger }
EOF
)"

function create_note {
  post_file_path=$ROOT/_posts/$(echo $TIMESTAMP | awk '{print $1}')-$(echo $TITLE | sed 's/ /_/g').md
  if test -f $post_file_path; then
    echo "File $post_file_path exists! Use another title"
    exit 1
  fi
  echo $template > $post_file_path
  /usr/local/bin/vscode $post_file_path
}

function publish_note {
  git -C $ROOT commit -a -m "$TITLE"
  git -C $ROOT push origin master
}

case $1 in
  "publish") publish_note;;
  "create") create_note;;
  *) echo "save|create action required";;
esac