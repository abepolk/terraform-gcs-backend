gcloud run deploy test-service --image "us-east1-docker.pkg.dev/$(gcloud config get-value project)/test-nginx-html-repo/test-image"