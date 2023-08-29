terraform {
    # Backend is local by default in Terraform
    required_providers {
        google = {
            source = "hashicorp/google"
            version = "4.78.0"
        }
    }
    required_version = "~> 1.5.5"
}

# This should be supplied from the command line via
# the terraform-<operation>-wrapper.sh one-line (for now) scripts.
# Except the terraform_init_wrapper.sh script.
# Do not enter interactively

variable "project_id" {
    type = string
}

provider "google" {
    project = var.project_id
    # No zone or region here because region and zone defined in
    # provider generally apply only to Compute and possibly a few
    # more esoteric services, and we are not
    # using Compute.
}

resource "random_id" "terraform_state_bucket_prefix" {
  byte_length = 8
}
