locals {
  vend_config = "${yamldecode(file("vending.yml"))}"
}
