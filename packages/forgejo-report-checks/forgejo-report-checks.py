from pyforgejo import AuthenticatedClient
from pyforgejo.api.repository import repo_create_status
from pyforgejo.models.create_status_option import CreateStatusOption
import json
from os import environ

client = AuthenticatedClient(base_url=environ["GITHUB_API_URL"], token=environ["GITHUB_TOKEN"])

with open('result.json', 'r') as file:
    data = json.load(file)

print("Reporting statuses acording to the following result.json")
print(json.dumps(data, indent=2))

for result in data['results']:
    attr = result['attr']
    success = result['success']
    type = result['type']
    print(f"Report status success={success} for {type} {attr}")
    response = repo_create_status.sync_detailed(
        owner="aciceri",
        repo="nixfleet",
        sha=environ["GITHUB_SHA"],
        client=client,
        body=CreateStatusOption(
            context=type,
            description=attr,
            target_url="https://git.aciceri.dev",  # FIXME
            state="success" if success else "failure"  # may be pending,success,failure,error_message
        )
    )

print("Done reporting statuses")
