// docker-bake.hcl
target "metadata-android" {}

target "default" {
  inherits = ["metadata-${platform}"]
  name = "ocpn-${platform}-builder"
  matrix = {
    platform = ["android"]
  }
  context = "docker"
  dockerfile = "Dockerfile.${platform}"
}
