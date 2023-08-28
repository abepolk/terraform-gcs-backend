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

locals {
    # TODO This needs to have a random string component because bucket
    # names must be globally unique

    terraform_state_bucket_name = "terraform_state_bucket"
    storage_location = "US-EAST1"
}

# This should be supplied from the command line via
# the terraform-<operation>-wrapper.sh one-line (for now) scripts.
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

# For now, while I'm using gcloud, get project ID from
# gcloud config get-value project

resource "google_compute_project_metadata_item" "terraform_state_bucket_name" {
    key = "terraform_state_bucket_name"
    value = local.terraform_state_bucket_name
}

resource "google_compute_project_metadata_item" "storage_location" {
    key = "storage_location"
    value = local.storage_location
}

resource "google_storage_bucket" "terraform_state_bucket" {
    name = local.terraform_state_bucket_name
    # `force_destroy = false` prevents the bucket from being
    # destroyed unless it is empty
    force_destroy = false
    location = local.storage_location 
    storage_class = "STANDARD"
    versioning {
        enabled = true
    }
    # No need for encryption because GCP encrypts objects by default

    # uniform_bucket_level_access disables ACLs, but these are only useful
    # in legacy contexts and migrations from AWS
    uniform_bucket_level_access = true
}
