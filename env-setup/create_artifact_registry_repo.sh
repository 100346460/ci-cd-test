export GCP_REGION="us-central1" # CHANGEME (OPT)
export GCP_ZONE="us-central1-a" # CHANGEME (OPT)
export NETWORK_NAME="default"

# enable apis
gcloud services enable compute.googleapis.com \
    artifactregistry.googleapis.com \
    cloudbuild.googleapis.com \
    storage.googleapis.com \
    run.googleapis.com

# set defaults
gcloud config set compute/region $GCP_REGION
gcloud config set compute/zone $GCP_ZONE

# create repository
export REPO_NAME="ci-cd-test"

gcloud artifacts repositories create $REPO_NAME \
    --repository-format=docker \
    --location=$GCP_REGION \
    --description="Docker repository"