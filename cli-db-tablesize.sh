#!/bin/bash

## filename     cli-db-tablesize.sh
## description: run "wp cli db size" on the console of each wordpress
##              showing the currently tables-sizes of each instance
## author:      jonas@sfxonline.de
## =======================================================================

for row in $(jq -r '.[] | @base64' data/sites.json); do
  _jq() {
    echo "${row}" | base64 --decode | jq -r "${1}"
  }

  echo
  echo '-----------------'
  _jq '.name'
  echo '-----------------'

  result=$(ssh "$(_jq '.host')" "$(_jq '.php') $(_jq '.wpcli') --path=$(_jq '.webroot') --format=json --allow-root db size --tables --human-readable")

  if jq -e . >/dev/null 2>&1 <<<"$result"; then
      echo $result | jq
  else
      echo $result
  fi

done
