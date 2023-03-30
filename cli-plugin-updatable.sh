#!/bin/bash

## filename     cli-plugin-updatable.sh
## description: run "wp cli plugin list" on the console of each wordpress
##              listing your currently installed wordpress plugins
##              filtering those where an update is available
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

  result=$(ssh "$(_jq '.host')" "$(_jq '.php') $(_jq '.wpcli') --path=$(_jq '.webroot') --format=json --allow-root plugin list --fields=name,status,update,version,update_version")

  if jq -e . >/dev/null 2>&1 <<<"$result"; then
      echo $result | jq '.[] | select(.update=="available")'
  else
      echo $result
  fi

done
