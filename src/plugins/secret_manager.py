import os
import io 
from dotenv import load_dotenv
from google.cloud import secretmanager
from functools import lru_cache

class AccessSecrets:

    def __init__(self,project_id):
        self.client = secretmanager.SecretManagerServiceClient()
        self.project_id = project_id
    def get_secrets_file(self, secret_id:str) -> dict:
        # Client to access the secrets manager
        name= f"projects/{self.project_id}/secrets/{secret_id}/versions/latest"
        try:
            # Making a request
            response= self.client.access_secret_version(request={'name':name})
            env_content = response.payload.data.decode("UTF-8")
            load_dotenv(stream=io.StringIO(env_content))
            env_vars={}
            for vars in os.environ:
                env_vars[vars] = os.environ.get(vars)
            return env_vars
        except Exception as e:
            print(f'Error in Secrets manager for {secret_id}:',str(e))

    def get_secret(self, secret_id:str,key:str) ->str:
        # Get a specific key value
        secrets = self.get_secrets_file(secret_id)
        return secrets.get(key)



