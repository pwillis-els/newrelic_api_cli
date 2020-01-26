# NewRelic API CLI

This is a Bash CLI tool for the NewRelic API.

## Requirements
 - Bash (probably version 4, only tested on Linux)
 - Curl

## Usage
Set the environment variable *NEWRELIC_API_TOKEN* to your NewRelic API token of choice, and then run:
```bash
$ ./newrelic_api_cli
```
Until all API functionality is implemented, there'll be a bunch of commands which will error out with "not implemented", so try out the commands you want to use first.

## Examples
```bash
$ NEWRELIC_API_TOKEN=<token here> ./newrelic_api_cli get alerts policies | jq .
{
  "policies": [
    {
      "id": 123456,
      "incident_preference": "PER_CONDITION_AND_TARGET",
      "name": "some-name-for-of-policy",
      "created_at": 1579740944885,
      "updated_at": 1579755815128
    }
  ]
}
```

## Contributing

Please feel free to send me patches to extend the supported API functions and I'll merge 'em. If you want to add extended functionality outside of just the API, please propose the work via an issue or pull request, so you don't end up doing a lot of work and then I ask you to change it all :-)


## TODO

Checked boxes are completed items.

### General features
 - [ ] Pagination

### REST API features
 - [ ] Applications
 - [ ] Application Hosts
 - [ ] Application Instances
 - [ ] Application Deployments
 - [ ] Mobile Applications
 - [ ] Browser Applications
 - [ ] Key Transactions
 - [ ] Usages
 - [ ] Users
 - [ ] Alerts Events
 - [ ] Alerts Conditions
   - [x] GET | List
 - [ ] Alerts Plugins Conditions
 - [ ] Alerts External Service Conditions
 - [ ] Alerts Synthetic Conditions
   - [x] GET | List
 - [ ] Alerts Location Failure Conditions
   - [x] GET | List
   - [x] POST | Create
   - [x] PUT | Update
   - [x] DELETE | Delete
 - [ ] Alerts Nrql Conditions
 - [ ] Alerts Policies
   - [x] GET | List
   - [x] DELETE | Delete
 - [ ] Alerts Channels
 - [ ] Alerts Policy Channels
 - [ ] Alerts Violations
 - [ ] Alerts Incidents
 - [ ] Alerts Entity Conditions
 - [ ] Dashboards
 - [ ] Plugins
 - [ ] Components
 - [ ] Labels
