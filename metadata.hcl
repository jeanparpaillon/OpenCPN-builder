// metadata.hcl
variable "TAG" {
  default = "latest"
}

target "metadata-android" {
  tags = [
    "ocpn-android-builder:${TAG}"
  ]
}
