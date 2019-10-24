import json

import boto3

with open('webapp-source/deploy.json') as input:
    print('Parsing deploy.json')
    data = json.load(input)

ssm = boto3.client('ssm')
role_name = data['role_name']
parameter_path = f'/alpha/webapp/{role_name}/secrets/'
parameters = ssm.get_parameters_by_path(
    Path=parameter_path,
    WithDecryption=True,
    MaxResults=999
).get('Parameters', [])
env_vars = {p['Name']: p['Value'] for p in parameters}
overrides = {'secretEnv': env_vars} if env_vars else {}

# The following are input values of the webapp helm chart
with open('parameter-store/env-vars.yaml', 'w') as output:
    json.dump(overrides, output)
print('Wrote parameter-store/env-vars.yaml')
