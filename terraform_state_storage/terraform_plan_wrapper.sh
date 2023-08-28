# TODO Check the ability of this to be interactive  if run in a subshell
terraform plan -var="project_id=$(gcloud config get-value project)"