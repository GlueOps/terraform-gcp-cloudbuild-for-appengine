variable "workspace" {}

variable "gcp_folder_id" {}
variable "github_org_name" {}
variable "github_repository_name" {}
variable "build_timeout" { default = "300s" }

variable "appengine_service_name" {}
variable "appengine_service_domains" {
  type = list(any)
}

variable "envs_requiring_build_approval" {
  type = list(any)
}


variable "plaintext" {}
variable "encrypted" {}

locals {
  plaintext = var.plaintext
  encrypted = var.encrypted

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