#!/bin/bash

## filename     cli-info.sh
## description: run "wp cli info" on the console of each website
##              listing information about your wp instances
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

  result=$(ssh "$(_jq '.host')" "$(_jq '.php') $(_jq '.wpcli') --path=$(_jq '.webroot') --format=json --allow-root --info")

  if jq -e . >/dev/null 2>&1 <<<"$result"; then
      echo $result | jq
  else
      echo $result
  fi

done
