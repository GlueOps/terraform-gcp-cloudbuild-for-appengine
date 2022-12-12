resource "google_monitoring_notification_channel" "email" {
  project      = local.project_name
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




# resource "google_monitoring_alert_policy" "gae_latency" {
#   project         = local.project_name
#   display_name = local.gae_latency_name
#   combiner     = "OR"
#   conditions {
#     display_name = "App Engine Latency Alert"
#     condition_threshold {
#       comparison      = "COMPARISON_GT"
#       duration        = "60s"
#       filter          = "metric.type=\"appengine.googleapis.com/http/server/response_latencies\" resource.type=\"gae_app\"" #metric.label.\"module_id\"=\"${var.appengine_service_name}\""
#       threshold_value = 3
#       trigger {
#         count = 1
#       }

#       aggregations {
#         per_series_aligner   = "ALIGN_SUM"
#         alignment_period     = "60s"
#         cross_series_reducer = "REDUCE_PERCENTILE_99"
#         group_by_fields      = ["resource.label.module_id"]
#       }
#     }
#   }
#   documentation {
#     content   = local.gae_latency_name
#     mime_type = "text/markdown"
#   }
#   enabled               = true
#   notification_channels = [google_monitoring_notification_channel.email.id]
# }



# resource "google_monitoring_alert_policy" "gae_memory" {
#   project         = local.project_name
#   display_name = local.gae_memory_name
#   combiner     = "OR"
#   conditions {
#     display_name = "App Engine Memory Alert"
#     condition_threshold {
#       comparison      = "COMPARISON_GT"
#       duration        = "60s"
#       filter          = "metric.type=\"appengine.googleapis.com/memory/usage\" resource.type=\"gae_app\" metric.label.\"module_id\"=\"${var.appengine_service_name}\""
#       threshold_value = 80
#       trigger {
#         count = 1
#       }
#     }
#   }
#   documentation {
#     content   = local.gae_memory_name
#     mime_type = "text/markdown"
#   }
#   enabled               = true
#   notification_channels = [google_monitoring_notification_channel.email.id]
# }

# resource "google_monitoring_alert_policy" "gae_cpu" {
#   project         = local.project_name
#   display_name = local.gae_cpu_name
#   combiner     = "OR"
#   conditions {
#     display_name = "App Engine CPU Alert"
#     condition_threshold {
#       comparison      = "COMPARISON_GT"
#       duration        = "60s"
#       filter          = "metric.type=\"appengine.googleapis.com/cpu/utilization\" resource.type=\"gae_app\" metric.label.\"module_id\"=\"${var.appengine_service_name}\""
#       threshold_value = 80
#       trigger {
#         count = 1
#       }
#     }
#   }
#   documentation {
#     content   = local.gae_cpu_name
#     mime_type = "text/markdown"
#   }
#   enabled               = true
#   notification_channels = [google_monitoring_notification_channel.email.id]
# }


# resource "google_monitoring_alert_policy" "gae_5xx" {
#   project         = local.project_name
#   display_name = "App Engine 5xx Alert"
#   combiner     = "OR"
#   conditions {
#     display_name = "App Engine 5xx Alert"
#     condition_threshold {
#       comparison      = "COMPARISON_GT"
#       duration        = "300s"
#       filter          = "metric.type=\"appengine.googleapis.com/http/server/response_count\" resource.type=\"gae_app\" metric.label.\"module_id\"=\"${var.appengine_service_name}\" metric.label.\"status\"=\"5xx\""
#       threshold_value = 5
#       trigger {
#         count = 1
#       }
#     }
#   }
#   documentation {
#     content   = "App Engine 5xx Alert for ${var.appengine_service_name} in ${local.project_name}"
#     mime_type = "text/markdown"
#   }
#   enabled               = true
#   notification_channels = [google_monitoring_notification_channel.email.id]
# }


# resource "google_monitoring_alert_policy" "gae_quota_denials" {
#   project         = local.project_name
#   display_name = local.gae_quota_name
#   combiner     = "OR"
#   conditions {
#     display_name = "App Engine Quota Denials Alert"
#     condition_threshold {
#       comparison      = "COMPARISON_GT"
#       duration        = "60s"
#       filter          = "metric.type=\"appengine.googleapis.com/http/server/quota_denial_count\" resource.type=\"gae_app\" metric.label.\"module_id\"=\"${var.appengine_service_name}\""
#       threshold_value = 0
#       trigger {
#         count = 1
#       }
#     }
#   }
#   documentation {
#     content   = local.gae_quota_name
#     mime_type = "text/markdown"
#   }
#   enabled               = true
#   notification_channels = [google_monitoring_notification_channel.email.id]
# }

# // create app engine alert for app engine service that has ANY ddos attacks during a 1 minute windows
# resource "google_monitoring_alert_policy" "gae_ddos" {
#   project         = local.project_name
#   display_name = local.gae_ddos_name
#   combiner     = "OR"
#   conditions {
#     display_name = "App Engine DDoS Alert"
#     condition_threshold {
#       comparison      = "COMPARISON_GT"
#       duration        = "60s"
#       filter          = "metric.type=\"appengine.googleapis.com/http/server/dos_intercept_count\" resource.type=\"gae_app\" metric.label.\"module_id\"=\"${var.appengine_service_name}\""
#       threshold_value = 0
#       trigger {
#         count = 1
#       }
#     }
#   }
#   documentation {
#     content   = "App Engine DDoS Alert for ${var.appengine_service_name} in ${local.project_name}"
#     mime_type = "text/markdown"
#   }
#   enabled               = true
#   notification_channels = [google_monitoring_notification_channel.email.id]
# }



locals {
  cpu_usage_metric    = "metric.type=\"appengine.googleapis.com/system/cpu/usage\" resource.type=\"gae_app\""
  memory_usage_metric = "metric.type=\"appengine.googleapis.com/system/memory/usage\" resource.type=\"gae_app\""
  # Unit is megacycles
  cpu_usage_threshold = 10000
  # Unit is bytes 
  memory_usage_threshold            = 512000000
  resource_usage_threshold_duration = "300s"
}

resource "google_monitoring_alert_policy" "gae-resource-usage-alert" {
  project               = local.project_name
  display_name          = "${local.project_name}-${var.appengine_service_name}-resource-usage-alert"
  combiner              = "OR"
  enabled               = true
  notification_channels = [google_monitoring_notification_channel.email.id]
  user_labels = {
    service = var.appengine_service_name
  }

  documentation {
    content   = "${local.project_name}-${var.appengine_service_name} app has been experiencing unusually high resource utilization for greater than 5 minutes"
    mime_type = "text/markdown"
  }

  conditions {
    display_name = "${local.project_name}-${var.appengine_service_name}-gae-cpu-usage"

    condition_threshold {
      threshold_value = local.cpu_usage_threshold
      comparison      = local.threshold_comparison.greater_than
      duration        = local.resource_usage_threshold_duration

      filter = local.cpu_usage_metric

      aggregations {
        per_series_aligner   = local.series_align_method.mean
        alignment_period     = local.alignment_period
        cross_series_reducer = local.reducer_method.sum
        group_by_fields      = [local.group_by_labels.module_id]
      }
    }
  }


}



locals {

  series_align_method = {
    mean       = "ALIGN_MEAN"
    count_true = "ALIGN_COUNT_TRUE"
    rate       = "ALIGN_RATE"
    sum        = "ALIGN_SUM"
  }
  alignment_period = "60s"

  reducer_method = {
    sum           = "REDUCE_SUM"
    none          = "REDUCE_NONE"
    count         = "REDUCE_COUNT"
    percentile_99 = "REDUCE_PERCENTILE_99"
  }

  group_by_labels = {
    response_code = "metric.label.response_code"
    module_id     = "resource.label.module_id"
  }

  threshold_comparison = {
    less_than    = "COMPARISON_LT"
    greater_than = "COMPARISON_GT"
  }

}




