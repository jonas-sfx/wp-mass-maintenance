#!/bin/bash

## filename     cli-theme-update-dryrun.sh
## description: run "wp cli theme update --all --dry-run" on the console
##              of each wordpress
##              listing your themes that could be updated
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

  result=$(ssh "$(_jq '.host')" "$(_jq '.php') $(_jq '.wpcli') --path=$(_jq '.webroot') --allow-root theme update --all --dry-run --format=json")

  if jq -e . >/dev/null 2>&1 <<<"$result"; then
      echo $result | jq
  else
      echo "$result"
  fi

done
