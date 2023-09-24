terraform {
    required_providers {
        google = {
            source = "hashicorp/google"
            version = "4.78.0"
        }
    }
    required_version = "~> 1.5.5"
}

locals {
    terraform_state_bucket_base_name = "terraform-state-bucket"
    location = "us-east1"
}

# This should be supplied from the command line via
# the terraform_<operation>_wrapper.sh one-line (for now) scripts.
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

resource "google_compute_project_metadata_item" "terraform_state_bucket_name" {
    key = "terraform_state_bucket_name"
    value = "${random_id.terraform_state_bucket_prefix.hex}-${local.terraform_state_bucket_base_name}"
}

resource "google_compute_project_metadata_item" "location" {
    key = "location"
    value = local.location
}

resource "google_storage_bucket" "terraform_state_bucket" {
    name = "${random_id.terraform_state_bucket_prefix.hex}-${local.terraform_state_bucket_base_name}"
    # `force_destroy = false` prevents the bucket from being
    # destroyed unless it is empty
    force_destroy = false
    location = upper(local.location)
    storage_class = "STANDARD"
    versioning {
        enabled = true
    }
    # No need for encryption because GCP encrypts objects by default

    # uniform_bucket_level_access disables ACLs, which are only useful
    # in legacy contexts and migrations from AWS
    uniform_bucket_level_access = true
}
