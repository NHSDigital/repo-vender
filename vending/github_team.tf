locals {

  default_teams = merge([for k, v in local.vend_config.programmes:
    {for k2, v2 in v.repositories:
      "${k}_${k2}" => {
        name =  "${v.name}-${v2.name}"
        key =  "${k}_${k2}"
        repository_key = k2
      }
}]...)

  teams = merge([for key_programme, value_programme in local.vend_config.programmes:
    {for key_group, value_group in value_programme.groups:
      "${key_programme}_${key_group}" => {
        key = "${key_programme}_${key_group}"
        name =  "${value_programme.name}-${value_group.name}"
        program_key = key_programme
        program_name = value_programme.name
        maintainers = value_group.maintainers
        members= value_group.membership
      }
}]...)

}

resource "github_team" "default_teams" {
  for_each    = {for k, v in local.default_teams: k => v if var.enable == true}
  name        = "${each.value.name}-members"
  description = "All members of ${each.value.name}"
  privacy     = "closed"
  create_default_maintainer = true
}

resource "github_team" "teams" {
  for_each    = {for k, v in local.teams: k => v if var.enable == true}
  name        = "${each.value.name}"
  description = "All members of ${each.value.name}"
  privacy     = "closed"
  create_default_maintainer = true
}
