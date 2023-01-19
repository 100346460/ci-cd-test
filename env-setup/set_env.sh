#!/bin/bash
read -p 'Please input ProjectID: ' projectid
export TEST='test'
export GCP_PROJECT_ID="${projectid}"
export PROJECT_NUMBER=$(gcloud projects describe "${GCP_PROJECT_ID}" --format='get(projectNumber)')
export BQ_DATASET_TEST="pipeline_${TEST}"
gcloud config set project "${GCP_PROJECT_ID}"

export PUBSUB_TOPIC='integration-test-complete-topic'
export PROD='prod'
export BQ_DATASET_PROD="pipeline_${PROD}"

export COMPOSER_REGION='us-central1'
export COMPOSER_ZONE_ID='us-central1-a'
export COMPOSER_ENV_NAME='data-pipeline-composer2'

export SOURCE_CODE_REPO='ci-cd-test'
export COMPOSER_DAG_NAME_TEST='ci-cd-dag-test'
export COMPOSER_DAG_NAME_PROD='ci-cd-dag-prod'
echo   "Environment variables set up."