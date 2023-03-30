#!/bin/bash

## filename     cli-db-export.sh
## description: run "wp cli db export" on the console of each wordpress
##              creating a nice dump of each instance
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

  ssh "$(_jq '.host')" "$(_jq '.php') $(_jq '.wpcli') --path=$(_jq '.webroot') --allow-root db export -" | zstd -q -o exports/$(date +"%Y%m%d-%H%M")-dump-$(_jq '.short').sql.zst

done
