variable "workspace" {}

variable "gcp_folder_id" {}
variable "github_org_name" {}
variable "github_repository_name" {}
variable "build_timeout" { default = "300s" }

variable "appengine_service_name" {}

variable "envs_requiring_build_approval" {
  type = list(any)
}


variable "plaintext" {}
variable "encrypted" {}

locals {
  plaintext = var.plaintext
  encrypted = var.encrypted
  variable_subsitition_step = [{
    name       = "launcher.gcr.io/google/ubuntu2004"
    entrypoint = "bash"
    args = [
      "-c",
      "curl -s https://raw.githubusercontent.com/GlueOps/gcp-cloudbuild-substitution-variables/main/gcsvh.sh | bash"
    ]
    env = [for k, v in local.all_vars : "${trim(k, "_")}=$${_${k}}"]
  }]

  plaintext_vars = [for key in local.plaintext[*] : { for k, v in key : k => v[var.workspace] }][0]
  secret_vars    = [for key in data.google_kms_secret.all_secrets[*] : { for k, v in key : k => v.plaintext }][0]
  all_vars       = merge(local.plaintext_vars, local.secret_vars)
}

variable "build_steps" {

  type = list(object(
    {
      name       = string
      entrypoint = string
      args       = list(string)
      env        = list(string)
    }
  ))
}
