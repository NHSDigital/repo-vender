locals {
  repo_teams = merge(flatten([for key_programme, value_programme in local.vend_config.programmes:
    [for key_repo, value_repo in value_programme.repositories:
    {for key_team, value_team in value_repo.groups:
      "${key_programme}_${key_repo}_${key_team}" => {
        key = "${key_programme}_${key_repo}_${key_team}"
        name =  "${value_programme.name}-${value_repo.name}-${key_team}"
        repo_key =  "${key_programme}_${key_repo}"
        team_key = "${key_programme}_${key_team}"
        default_team_key = "${key_programme}_${key_repo}"
        team_access = value_team.role
      }
}]])...)

}

resource "github_team_repository" "default_team_access" {
  for_each    = {for k, v in local.default_teams: k => v if var.enable == true}
  team_id    = github_team.default_teams[each.key].id
  repository = github_repository.repositories[each.value.key].name
  permission = "pull"
}


resource "github_team_repository" "team_access" {
  for_each    = {for k, v in local.repo_teams: k => v if var.enable == true}
  team_id    = github_team.teams[each.value.team_key].id
  repository = github_repository.repositories[each.value.repo_key].name
  permission = each.value.team_access
}



