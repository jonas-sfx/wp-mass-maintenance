#!/bin/bash

## filename     cli-plugin-checksums.sh
## description: run "wp cli plugin verify-checksums" on the console of each
##              wordpress instance.
##              checking the file-checksums
##              of your currently installed wordpress plugins
## author:      jonas@sfxonline.de
## ============================================================================

for row in $(jq -r '.[] | @base64' data/sites.json); do

  _jq() {
    echo "${row}" | base64 --decode | jq -r "${1}"
  }

  echo
  echo '-----------------'
  _jq '.name'
  echo '-----------------'

  result=$(ssh "$(_jq '.host')" "$(_jq '.php') $(_jq '.wpcli') --path=$(_jq '.webroot') --format=json --allow-root plugin verify-checksums --all")

  if jq -e . >/dev/null 2>&1 <<<"$result"; then
      echo $result | jq
  else
      echo $result
  fi

done
