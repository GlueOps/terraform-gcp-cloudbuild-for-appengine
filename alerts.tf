resource "google_monitoring_notification_channel" "email" {
  display_name = "GAE-${local.project_name}-${var.appengine_service_name}"
  type         = "email"
  labels = {
    email_address = var.slack_channel_email
  }
  force_delete = false
}

locals {
  gae_latency_name = "${local.project_name}-${var.appengine_service_name} - App Engine LATENCY Alert"
  gae_memory_name  = "${local.project_name}-${var.appengine_service_name} - App Engine MEMORY Alert"
  gae_cpu_name     = "${local.project_name}-${var.appengine_service_name} - App Engine CPU Alert"
  gae_ddos_name    = "${local.project_name}-${var.appengine_service_name} - App Engine DDOS Alert"
  gae_quota_name   = "${local.project_name}-${var.appengine_service_name} - App Engine QUOTA Alert"

}


resource "google_monitoring_alert_policy" "gae_latency" {
  display_name = local.gae_latency_name
  combiner     = "OR"
  conditions {
    display_name = "App Engine Latency Alert"
    condition_threshold {
      comparison      = "COMPARISON_GT"
      duration        = "60s"
      filter          = "metric.type=\"appengine.googleapis.com/http/server/response_latencies\" resource.type=\"gae_app\" metric.label.\"module_id\"=\"${var.appengine_service_name}\""
      threshold_value = 3
      trigger {
        count = 1
      }
    }
  }
  documentation {
    content   = local.gae_latency_name
    mime_type = "text/markdown"
  }
  enabled               = true
  notification_channels = [google_monitoring_notification_channel.email.id]
}



resource "google_monitoring_alert_policy" "gae_memory" {
  display_name = local.gae_memory_name
  combiner     = "OR"
  conditions {
    display_name = "App Engine Memory Alert"
    condition_threshold {
      comparison      = "COMPARISON_GT"
      duration        = "60s"
      filter          = "metric.type=\"appengine.googleapis.com/memory/usage\" resource.type=\"gae_app\" metric.label.\"module_id\"=\"${var.appengine_service_name}\""
      threshold_value = 80
      trigger {
        count = 1
      }
    }
  }
  documentation {
    content   = local.gae_memory_name
    mime_type = "text/markdown"
  }
  enabled               = true
  notification_channels = [google_monitoring_notification_channel.email.id]
}

resource "google_monitoring_alert_policy" "gae_cpu" {
  display_name = local.gae_cpu_name
  combiner     = "OR"
  conditions {
    display_name = "App Engine CPU Alert"
    condition_threshold {
      comparison      = "COMPARISON_GT"
      duration        = "60s"
      filter          = "metric.type=\"appengine.googleapis.com/cpu/utilization\" resource.type=\"gae_app\" metric.label.\"module_id\"=\"${var.appengine_service_name}\""
      threshold_value = 80
      trigger {
        count = 1
      }
    }
  }
  documentation {
    content   = local.gae_cpu_name
    mime_type = "text/markdown"
  }
  enabled               = true
  notification_channels = [google_monitoring_notification_channel.email.id]
}


resource "google_monitoring_alert_policy" "gae_5xx" {
  display_name = "App Engine 5xx Alert"
  combiner     = "OR"
  conditions {
    display_name = "App Engine 5xx Alert"
    condition_threshold {
      comparison      = "COMPARISON_GT"
      duration        = "300s"
      filter          = "metric.type=\"appengine.googleapis.com/http/server/response_count\" resource.type=\"gae_app\" metric.label.\"module_id\"=\"${var.appengine_service_name}\" metric.label.\"status\"=\"5xx\""
      threshold_value = 5
      trigger {
        count = 1
      }
    }
  }
  documentation {
    content   = "App Engine 5xx Alert for ${var.appengine_service_name} in ${local.project_name}"
    mime_type = "text/markdown"
  }
  enabled               = true
  notification_channels = [google_monitoring_notification_channel.email.id]
}


resource "google_monitoring_alert_policy" "gae_quota_denials" {
  display_name = local.gae_quota_name
  combiner     = "OR"
  conditions {
    display_name = "App Engine Quota Denials Alert"
    condition_threshold {
      comparison      = "COMPARISON_GT"
      duration        = "60s"
      filter          = "metric.type=\"appengine.googleapis.com/http/server/quota_denial_count\" resource.type=\"gae_app\" metric.label.\"module_id\"=\"${var.appengine_service_name}\""
      threshold_value = 0
      trigger {
        count = 1
      }
    }
  }
  documentation {
    content   = local.gae_quota_name
    mime_type = "text/markdown"
  }
  enabled               = true
  notification_channels = [google_monitoring_notification_channel.email.id]
}

// create app engine alert for app engine service that has ANY ddos attacks during a 1 minute windows
resource "google_monitoring_alert_policy" "gae_ddos" {
  display_name = local.gae_ddos_name
  combiner     = "OR"
  conditions {
    display_name = "App Engine DDoS Alert"
    condition_threshold {
      comparison      = "COMPARISON_GT"
      duration        = "60s"
      filter          = "metric.type=\"appengine.googleapis.com/http/server/dos_intercept_count\" resource.type=\"gae_app\" metric.label.\"module_id\"=\"${var.appengine_service_name}\""
      threshold_value = 0
      trigger {
        count = 1
      }
    }
  }
  documentation {
    content   = "App Engine DDoS Alert for ${var.appengine_service_name} in ${local.project_name}"
    mime_type = "text/markdown"
  }
  enabled               = true
  notification_channels = [google_monitoring_notification_channel.email.id]
}
