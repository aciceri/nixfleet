from pyforgejo import AuthenticatedClient
from pyforgejo.api.repository import repo_create_status
from pyforgejo.models.create_status_option import CreateStatusOption
import json
from os import environ

client = AuthenticatedClient(base_url=environ["GITHUB_API_URL"], token=environ["GITHUB_TOKEN"])

print("hello")

with open('result.json', 'r') as file:
    data = json.load(file)

for result in data['results']:
    attr = result['attr']
    success = result['success']
    type = result['type']
    print(attr)
    response = repo_create_status.sync_detailed(
        owner="aciceri",
        repo="nixfleet",
        sha=environ["GITHUB_SHA"],
        client=client,
        body=CreateStatusOption(
            context=type,
            description=attr,
            target_url="https://google.com",
            state="success" if success else "failure"  # ma be pending,success,failure,error_message
        )
    )
