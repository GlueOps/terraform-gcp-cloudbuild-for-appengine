resource "google_app_engine_application_url_dispatch_rules" "web_service" {
  project = local.project_name

  dynamic "dispatch_rules" {
    for_each = var.appengine_service_domains
    content {
      domain  = dispatch_rules.value
      path    = "/*"
      service = var.appengine_service_name
    }
  }
}

resource "google_app_engine_domain_mapping" "domain_mapping" {
  project     = local.project_name
  for_each    = var.appengine_service_domains
  domain_name = each.value

  ssl_settings {
    ssl_management_type = "AUTOMATIC"
  }
}

