#!/bin/bash

# adds the Cloud Composer v2 API Service Agent Extension
gcloud projects add-iam-policy-binding $GCP_PROJECT_ID \
    --member serviceAccount:service-$PROJECT_NUMBER@cloudcomposer-accounts.iam.gserviceaccount.com \
    --role roles/composer.ServiceAgentV2Ext

# adding bigquery permissions to create and delete in project
gcloud projects add-iam-policy-binding $GCP_PROJECT_ID \
    --member serviceAccount:service-$PROJECT_NUMBER@cloudcomposer-accounts.iam.gserviceaccount.com \
    --role roles/bigquery.dataOwner

# creates the Cloud Composer environment
gcloud composer environments create $COMPOSER_ENV_NAME \
    --location $COMPOSER_REGION \
    --image-version composer-2.0.14-airflow-2.2.5

# set composer variables in the composer environment, variables are needed for the data-processing DAG
COMPOSER_VAR_FILE=composer_variables.json
if [ ! -f "${COMPOSER_VAR_FILE}" ]; then
    echo "Generate composer variable file ${COMPOSER_VAR_FILE}."
    envsubst < composer_variables.template > ${COMPOSER_VAR_FILE}
fi

gcloud composer environments storage data import \
--environment ${COMPOSER_ENV_NAME} \
--location ${COMPOSER_REGION} \
--source ${COMPOSER_VAR_FILE}

gcloud composer environments run \
${COMPOSER_ENV_NAME} \
--location ${COMPOSER_REGION} \
variables import -- /home/airflow/gcs/data/${COMPOSER_VAR_FILE}

# create the dag bucket as an environment variable
export COMPOSER_DAG_BUCKET=$(gcloud composer environments describe $COMPOSER_ENV_NAME \
    --location $COMPOSER_REGION \
    --format="get(config.dagGcsPrefix)")

# get the service account name
export COMPOSER_SERVICE_ACCOUNT=$(gcloud composer environments describe $COMPOSER_ENV_NAME \
    --location $COMPOSER_REGION \
    --format="get(config.nodeConfig.serviceAccount)")