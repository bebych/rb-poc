### Include top-level configuration
include {
  path = find_in_parent_folders()
}

dependencies {
  paths = [
    "../shared-dev/",
  ]
}

# vim:filetype=terraform ts=2 sw=2 et:
