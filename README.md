# NewRelic API CLI

In this repo are some Bash CLI tools to manipulate different NewRelic APIs.

These are the cli tools included:
 - `newrelic_rest_cli` - The REST API (aren't they all REST APIs?)
 - `newrelic_synthetics_cli` - The Synthetics API

## Requirements
 - Bash (probably version 4, only tested on Linux)
 - Curl

## Usage
Set the environment variable *NEWRELIC_API_TOKEN* to your NewRelic API token of choice, and then run one of the scripts.
```bash
$ ./newrelic_rest_cli
Usage: ./newrelic_rest_cli COMMAND
Commands:
        get
        delete
        create
        update
```
Until all API functionality is implemented, there'll be a bunch of commands which will error out with "not implemented", so try out the commands you want to use first.

Note: these scripts will return '1' as exit status if they receive a non-2xx HTTP response. To determine the actual HTTP response code, check *STDERR*.

## Examples
```bash
$ NEWRELIC_API_TOKEN=<token here> ./newrelic_rest_cli get alerts policies | jq .
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

Note: This is probably an incomplete list of the features left to implement. Checked boxes are completed items.

### General features
 - [ ] Pagination (this may need to be implemented per API call, so you can add them to individual items below as they're completed)

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

### Synthetics API features
 - [x] All Monitors
   - [x] GET | List
 - [x] Monitors
   - [x] GET | List
   - [x] POST | Create
   - [x] PUT | Update
   - [x] PATCH | Patch
   - [x] DELETE | Delete
 - [x] Monitor Locations
   - [x] GET | List
 
