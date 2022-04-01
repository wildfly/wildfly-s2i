#!/bin/bash

extract_version() {
  filter=$1
  images=$(docker images $filter)

  while IFS= read -r line ; 
  do
    array=($line)
    version=${array[1]}
    if [ $version != "TAG" ] && [ $version != "latest" ]; then
      local result=$version
    fi
  done <<< "$images"
  echo ${result}
}
echo "$(extract_version $1)"
