import os
import json

import boto3

ssm = boto3.client('ssm')
app_name = os.environ.get('APP_NAME')
role_name = f'alpha_app_{app_name}'
parameter_path = f'/alpha/webapp/{role_name}/secrets/'
parameters = ssm.get_parameters_by_path(
    Path=parameter_path,
    WithDecryption=True,
    MaxResults=10
).get('Parameters', [])
env_vars = {os.path.basename(p['Name']): p['Value'] for p in parameters}

overrides = {'secretEnv': env_vars} if env_vars else {}

# The following are input values of the webapp helm chart
with open('parameter-store/env-vars.yaml', 'w') as output:
    json.dump(overrides, output)
print('Wrote parameter-store/env-vars.yaml')
