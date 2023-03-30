#!/bin/bash

## filename     cli-user-list.sh
## description: run "wp cli user list" on the console of each wordpress
##              listing the users there
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

  result=$(ssh "$(_jq '.host')" "$(_jq '.php') $(_jq '.wpcli') --path=$(_jq '.webroot') --format=json --allow-root user list --fields=ID,user_login,display_name,user_email,user_registered,roles,caps")

  if jq -e . >/dev/null 2>&1 <<<"$result"; then
      echo $result | jq
  else
      echo $result
  fi

done
