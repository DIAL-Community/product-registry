#!/usr/bin/env bash
rm -rf temp-linecount-repo &&
  git clone --depth 1 "$1" temp-linecount-repo &&
  printf "('temp-linecount-repo' will be deleted automatically)\n\n\n" &&
  cloc --exclude-ext=yml,json,yaml,xml --csv --out=repodata.csv temp-linecount-repo &&
  rm -rf temp-linecount-repo
