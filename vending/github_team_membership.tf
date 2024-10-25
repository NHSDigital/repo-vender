locals {

  repo_default_members = merge(flatten([for key_programme, value_programme in local.vend_config.programmes :
    [for key_repo, value_repo in value_programme.repositories :
      { for key_member, value_member in value_programme.members :
        "${key_programme}_${key_member}" => {
          key              = "${key_programme}_${key_member}"
          name             = "${value_programme.name}-${key_member}"
          repo_key         = "${key_programme}_${key_repo}"
          default_team_key = "${key_programme}_${key_repo}"
          github_name      = value_member.github
          member_key = key_member
          default_maintainer = value_programme.default_maintainer
        }
  }]])...)

  members = merge([for key_programme, value_programme in local.vend_config.programmes :
    { for key_member, value_member in value_programme.members :
      "${key_programme}_${key_member}" => {
        key         = "${key_programme}_${key_member}"
        name        = "${value_programme.name}-${key_member}"
        github_name = value_member.github
      }
  }]...)


  team_members = merge([for key_team, value_team in local.teams :
    { for member_key, member_value in value_team.members : "${key_team}_${member_value}" =>
      {
        member_list_key = "${value_team.program_key}_${member_value}"
        team_key        = value_team.key
        team_name       = value_team.name
        name            = member_value
      }
  }]...)

  team_maintainers = merge([for key_team, value_team in local.teams :
    { for maintainer_key, maintainer_value in value_team.maintainers :  "${key_team}_${maintainer_value}" =>
      {
        member_list_key = "${value_team.program_key}_${maintainer_value}"
        team_key        = value_team.key
        team_name       = value_team.name
        name            = maintainer_value
      }
  }]...)
}


resource "github_team_membership" "default_teams_membersip" {
  for_each = { for k, v in local.repo_default_members : k => v if var.enable == true}
  team_id  = github_team.default_teams[each.value.default_team_key].id
  username = each.value.github_name
  role     = each.value.default_maintainer == each.value.member_key ? "maintainer" : "member"
}


resource "github_team_membership" "team_membership" {
  for_each = { for k, v in local.team_members : k => v if var.enable == true}
  team_id  = github_team.teams[each.value.team_key].id
  username = local.members[each.value.member_list_key].github_name
  role     = "member"
}


resource "github_team_membership" "team_maintainers" {
  for_each = { for k, v in local.team_maintainers : k => v if var.enable == true }
  team_id  = github_team.teams[each.value.team_key].id
  username = local.members[each.value.member_list_key].github_name
  role     = "maintainer"
}
