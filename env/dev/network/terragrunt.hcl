terraform {
  source = "${include.envcommon.locals.base_source_url}?ref=master"
}

include "root" {
  path = find_in_parent_folders()
}

include "envcommon" {
  path   = "${dirname(find_in_parent_folders())}/service/network.hcl"
  expose = true
}
