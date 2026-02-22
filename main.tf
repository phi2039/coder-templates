terraform {
  required_providers {
    coderd = {
      source = "coder/coderd"
    }
  }
#   backend "gcs" {
#     bucket = "coder-dogfood-tf-state"
#   }
}

# import {
#   to = coderd_template.envbuilder_dogfood
#   id = "e75f1212-834c-4183-8bed-d6817cac60a5"
# }

data "coderd_organization" "default" {
  is_default = true
}

data "coderd_user" "machine" {
  username = "machine"
}

variable "CODER_TEMPLATE_VERSION" {
  type = string
}

variable "CODER_TEMPLATE_MESSAGE" {
  type = string
}

# variable "CODER_DOGFOOD_ANTHROPIC_API_KEY" {
#   type        = string
#   description = "The API key that workspaces will use to authenticate with the Anthropic API."
#   default     = ""
#   sensitive   = true
# }

# One resource per template...
resource "coderd_template" "k8s-devcontainer" {
  name            = "devcontainers-k8s"
  display_name    = "Devcontainer (Kubernetes)"
  description     = "The template to use when developing in a devcontainer"
  icon            = "/icon/container.svg"
  organization_id = data.coderd_organization.default.id
  versions = [
    {
      name      = var.CODER_TEMPLATE_VERSION
      message   = var.CODER_TEMPLATE_MESSAGE
      directory = "devcontainers-k8s"
      active    = true
      tf_vars = [
        # {
        #   name  = "anthropic_api_key"
        #   value = var.CODER_DOGFOOD_ANTHROPIC_API_KEY
        # },
        # {
        #   name  = "envbuilder_cache_dockerconfigjson_path"
        #   value = "/home/coder/envbuilder-cache-dockerconfig.json"
        # }
      ]
    }
  ]
  # acl = {
  #   groups = [{
  #     id   = data.coderd_organization.default.id
  #     role = "use"
  #   }]
  #   users = [{
  #     id   = data.coderd_user.machine.id
  #     role = "admin"
  #   }]
  # }
  activity_bump_ms                  = 10800000
  allow_user_auto_start             = true
  allow_user_auto_stop              = true
  allow_user_cancel_workspace_jobs  = false
  auto_start_permitted_days_of_week = ["friday", "monday", "saturday", "sunday", "thursday", "tuesday", "wednesday"]
  auto_stop_requirement = {
    days_of_week = ["sunday"]
    weeks        = 1
  }
  default_ttl_ms                 = 28800000
  deprecation_message            = null
  failure_ttl_ms                 = 604800000
  require_active_version         = true
  time_til_dormant_autodelete_ms = 7776000000
  time_til_dormant_ms            = 8640000000
}
