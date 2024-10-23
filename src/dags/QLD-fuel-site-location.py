import datetime
import json

import requests
import pandas as pd
from airflow import DAG
from airflow.operators.python import PythonOperator
from airflow.exceptions import AirflowException
from airflow.models import Variable

from secret_manager import AccessSecrets

default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'email_on_failure': True,
    'email_on_retry': False,
    'retries': 3,
    'retry_delay': datetime.timedelta(minutes=5),
    'execution_timeout': datetime.timedelta(minutes=30),
    'sla': datetime.timedelta(hours=1)
}

class APIfetch:
    def __init__(self, api_url:str,api_key:str):
        self.url = api_url
        self.headers = {
            'Authorization':f'FPDAPI SubscriberToken={api_key}'
        }

    def get_data_from_api(self):

        """
        Getthing data from API and loading it in json format
        """

        try:
            response =  requests.get(self.url, headers=self.headers)
            response.raise_for_status()
            return response.json()
        except requests.exceptions.RequestException as e:
            raise AirflowException(f"Failed to get API response for {self.url}:", str(e))


def extract_data(**context):
    
    secret_client = AccessSecrets(project_id='upbeat-airfoil-439209-q3')    
    API_KEY  =  secret_client.get_secret(key="consumer_token_QLD")
    try:
        extractor = APIfetch(api_key=API_KEY, api_url='https://fppdirectapi-prod.fuelpricesqld.com.au/Subscriber/GetFullSiteDetails?countryId=21&geoRegionLevel=3&geoRegionId=1')
        data = extractor.get_data_from_api()

        context['task_instance'].xcom_push(key='raw_data',value=data)
        return True
    except Exception as e:
        raise AirflowException('Data extraction failed:',str(e))

with DAG(
        dag_id='QLD-api',
        dag_display_name='QLD Fuel Site Extraction', 
         description=' This DAG extract static fuel sites data from API whihc needs to be transformed',
         schedule=' 0 1 * * *',
         start_date=datetime.datetime(2024,10,22),
         tags=['QLD','API'],
         catchup=False) as dag:
    extract_task = PythonOperator(
        task_id='API data extraction',
        python_callable= extract_data,
        provide_context= True
    )

extract_task