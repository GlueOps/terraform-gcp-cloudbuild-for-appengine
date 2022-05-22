locals {
  project_name = data.google_projects.env_project.projects[0].project_id
}

data "google_projects" "env_project" {
  filter = "lifecycleState:ACTIVE labels.environment=${var.workspace} parent.type:folder parent.id:${var.gcp_folder_id}"
}


resource "google_cloudbuild_trigger" "trigger" {
  project         = local.project_name
  service_account = "projects/${local.project_name}/serviceAccounts/${local.project_name}@appspot.gserviceaccount.com"

  name = var.appengine_service_name

  github {
    name  = var.github_repository_name # Note: REPO must be connected first! Go to triggers -> Manage Repositories -> Ensure Global Region is Selected and then click on Connect Repository. DO NOT create a sample trigger!
    owner = var.github_org_name

    push {
      branch       = "^main$"
      invert_regex = false
    }
  }

  dynamic "build" {
    for_each = toset([var.appengine_service_name])
    content {
      timeout = var.build_timeout
      options {
        logging = "STACKDRIVER_ONLY"
      }

      dynamic "step" {
        for_each = concat(var.build_steps,local.variable_subsitition_step)
        content {
          # args - (optional) is a type of list of string
          args = step.value["args"]
          # entrypoint - (optional) is a type of string
          entrypoint = step.value["entrypoint"]
          # env - (optional) is a type of list of string
          env = step.value["env"]
          # name - (required) is a type of string
          name = step.value["name"]
        }
      }



    }
  }



  substitutions = { for k, v in local.all_vars : "_${k}" => v }

  approval_config {
    approval_required = contains(var.envs_requiring_build_approval, var.workspace) ? true : false
  }

}


