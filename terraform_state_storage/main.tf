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
    project_id = "portfolio-website-383014"
    region = "US-EAST1"
    # TODO correct capitalization if we are still using "zone"
    zone = "us-east1-b"
    terraform_state_bucket_name = "terraform_state_bucket"
}

provider "google" {
    project = local.project_id
    region = local.region
    zone = local.zone
}

# For now, while I'm using gcloud, get project ID from
# gcloud compute project-info describe --format="value(name)"

resource "google_compute_project_metadata_item" "region" {
    key = "region"
    value = local.region
}

resource "google_compute_project_metadata_item" "zone" {
    key = "zone"
    value = local.zone
}

resource "google_compute_project_metadata_item" "terraform_state_bucket_name" {
    key = "terraform_state_bucket_name"
    value = local.terraform_state_bucket_name
}

resource "google_storage_bucket" "terraform_state_bucket" {
    name = locals.terraform_state_bucket_name
    force_destroy = false
    # TODO is location necessary if we are already putting region and zone in the provider?
}