#!/bin/bash

set -e
# set -x
set -o pipefail

ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S %z')

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
  esac
done

if [[ -z $TITLE ]]; then
    echo "-t | --title artgument required"
    exit 1
fi

post_file_path=$ROOT/_posts/$(echo $TIMESTAMP | awk '{print $1}')-$(echo $TITLE | sed 's/ /_/g').md

cat <<EOT >> $post_file_path
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
---
EOT

/usr/local/bin/vscode $post_file_path