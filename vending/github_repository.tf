locals {
  repos = merge([for k, v in local.vend_config.programmes:
    {for k2, v2 in v.repositories:
      "${k}_${k2}" => {
        name =  "${v.name}-${v2.name}"
        visibility = v2.visibility
        template_owner = v2.template.owner
        template_repository = v2.template.repository
      }
}]...)
}


resource "github_repository" "repositories" {
  for_each    = {for k, v in local.repos: k => v if var.enable == true}
  name        = each.value.name
  description = "My awesome codebase"
  visibility  = each.value.visibility

  template {
    owner                =  each.value.template_owner
    repository           = each.value.template_repository
    include_all_branches = false
  }
}
