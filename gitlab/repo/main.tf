resource "gitlab_project" "repo" {
  name         = var.name
  namespace_id = var.namespace_id
  description  = var.description
  topics       = var.topics

  import_url = var.import_url

  visibility_level = var.visibility_level
  default_branch   = var.default_branch

  ci_push_repository_for_job_token_allowed    = var.ci_push_repository_for_job_token_allowed
  ci_pipeline_variables_minimum_override_role = var.ci_pipeline_variables_minimum_override_role

  merge_method                          = "ff"
  squash_option                         = "default_on"
  remove_source_branch_after_merge      = true
  only_allow_merge_if_pipeline_succeeds = var.only_allow_merge_if_pipeline_succeeds
  allow_merge_on_skipped_pipeline       = false
}

resource "gitlab_branch_protection" "main" {
  project          = gitlab_project.repo.id
  branch           = var.default_branch
  allow_force_push = false

  # gitlab provider v19 replaced the flat push_access_level / merge_access_level
  # fields with list-of-objects attributes. Single-element lists preserve the
  # prior behavior.
  allowed_to_push = [
    {
      access_level = var.push_access_level
    },
  ]
  allowed_to_merge = [
    {
      access_level = "maintainer"
    },
  ]
}

resource "gitlab_project_push_mirror" "github" {
  count = var.mirror_url != null ? 1 : 0

  project                 = gitlab_project.repo.id
  url                     = var.mirror_url
  enabled                 = true
  only_protected_branches = true
  keep_divergent_refs     = false
}

moved {
  from = gitlab_project_mirror.github
  to   = gitlab_project_push_mirror.github
}

resource "gitlab_pipeline_schedule" "schedules" {
  for_each = var.schedules

  project     = gitlab_project.repo.id
  description = each.value.description
  ref         = each.value.ref
  cron        = each.value.cron
  active      = each.value.active
}

resource "gitlab_project_variable" "vars" {
  for_each = var.pipeline_variables

  project       = gitlab_project.repo.id
  key           = each.key
  value         = each.value.value
  masked        = each.value.masked
  variable_type = each.value.variable_type
  protected     = each.value.protected
}
