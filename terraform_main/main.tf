terraform {
    # Backend is local by default in Terraform
    required_providers {
        google = {
            source = "hashicorp/google"
            version = "4.78.0"
        }
    }
    required_version = "~> 1.5.5"
    # The only information to configure the backend is the bucket name,
    # and we are getting that from project metadata and passing in through
    # the CLI. Here we just say which backend we are using.
    backend "gcs" {}
}

# This should be supplied from the command line via
# the terraform-<operation>-wrapper.sh one-line (for now) scripts.
# Except the terraform_init_wrapper.sh script.
# Do not enter interactively

variable "project_id" {
    type = string
}

variable "location" {
    type = string
}

provider "google" {
    project = var.project_id
    # No zone or region here because region and zone defined in
    # provider generally apply only to Compute and possibly a few
    # more esoteric services, and we are not
    # using Compute.
}

###################################################
#
# Insert resources for the main infrastructure here
#
###################################################

# For example:

resource "random_id" "hello_world_id" {
  byte_length = 8
}

resource "google_storage_bucket" "hello_world" {
    name = "${random_id.hello_world_id.hex}-hello-world"
    location = var.location
    storage_class = "STANDARD"
    # uniform_bucket_level_access disables ACLs, which are only useful
    # in legacy contexts and migrations from AWS
    uniform_bucket_level_access = true
}