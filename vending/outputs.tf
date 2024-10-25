
output "programme_name" {
  value = {
    repos = local.repos
    members= local.members
    teams = local.teams
    team_members= local.team_members
    repo_teams= local.repo_teams
  }
}
