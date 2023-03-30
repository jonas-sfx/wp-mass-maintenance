#!/bin/bash

## filename     cli-core-version.sh
## description: run "wp cli core version" on the console of each website
##              listing information about your wp core version
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

  ssh "$(_jq '.host')" "$(_jq '.php') $(_jq '.wpcli') --path=\"$(_jq '.webroot')\" --allow-root core version --extra"
done
