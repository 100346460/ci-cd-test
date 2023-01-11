#!/bin/bash
gcloud config set project data-pipeline-interactive
export TEST='test'
export GCP_PROJECT_ID='data-pipeline-interactive'
export PROJECT_NUMBER=$(gcloud projects describe "${GCP_PROJECT_ID}" --format='get(projectNumber)')
export BQ_DATASET_TEST="pipeline_${TEST}"

export PUBSUB_TOPIC='integration-test-complete-topic'
export PROD='prod'
export BQ_DATASET_PROD="pipeline_${PROD}"

export COMPOSER_REGION='us-central1'
export COMPOSER_ZONE_ID='us-central1-a'
export COMPOSER_ENV_NAME='data-pipeline-composer'

export SOURCE_CODE_REPO='ci-cd-test'
export COMPOSER_DAG_NAME_TEST='ci-cd-dag-test'
export COMPOSER_DAG_NAME_PROD='ci-cd-dag-prod'
echo   "Environment variables set up."