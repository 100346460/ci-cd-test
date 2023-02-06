# Copyright 2019 Google Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#         http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
"""Data processing test workflow definition.
"""
import datetime
from base64 import b64encode
from airflow import models
from airflow.operators.python import PythonOperator
from airflow.contrib.operators.kubernetes_pod_operator import KubernetesPodOperator
from airflow.providers.google.cloud.operators.pubsub import PubSubPublishMessageOperator
# from airflow.contrib.operators.dataflow_operator import PythonOperator

pubsub_topic = models.Variable.get('pubsub_topic')
project = models.Variable.get('gcp_project')

yesterday = datetime.datetime.combine(
    datetime.datetime.today() - datetime.timedelta(1),
    datetime.datetime.min.time())

def my_func():
    print("Hello :)")

with models.DAG(
    'test-dbt-dag',
    schedule_interval=None) as dag:
    
    python_task = PythonOperator(
    task_id='execute_my_func',
    python_callable=my_func,
    start_date=yesterday
   )

    dbt_run_task = KubernetesPodOperator(
        task_id='dbt-run',
        name='dbt-run',
        namespace='default',
        image='us-central1-docker.pkg.dev/data-pipeline-interactive/ci-cd-test/ci-cd-dbt:latest',
        cmds=['/bin/bash',"-c","dbt deps"],
        image_pull_policy="Always",
        get_logs=True,
        start_date=yesterday
   )

    publish_task = PubSubPublishMessageOperator(
      task_id='publish_test_complete',
      project=project,
      topic=pubsub_topic,
      messages=[{'data': b64encode('successful'.encode())}],
      start_date=yesterday
  )

    python_task >> dbt_run_task >> publish_task