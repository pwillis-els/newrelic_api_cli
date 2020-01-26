# Location Failure Conditions example

The example in this directory will use the `newrelic_rest_cli` and `newrelic_synthetics_cli` scripts to create new alert conditions using the *location_failure_conditions* alert condition type. It does this on existing policies and monitors, so you must create those first.

The idea here is that you have some alert policies and some synthetic monitors, and you want to create an alert condition so that you only alert when **all** of the locations are erroring (for example, to avoid one monitor location triggering the alert when the service is still working elsewhere).

The `fix_policies.sh` script looks up a set of policies and monitors and applies fixes on them. You'll either need an equal number of policies (with *-syn* in the name) and monitors, or you should modify this script to iterate over the policies and monitors you want to create the conditions against.

## Usage
1. Modify the `synthetic-multi-location-health-check.json.tmpl` file to fit the data you want to use to create the new alert condition. Note that this is a template, some values are replaced on the fly. The only place the values are documented seems to be in the API explorer link below :(
2. Set your *NEWRELIC_API_KEY* environment variable
3. Add the current directory to your *PATH* environment variable
3. Run `./fix_policies.sh`

# Links
 - https://docs.newrelic.com/docs/alerts/new-relic-alerts/defining-conditions/multi-location-synthetics-alert-conditions
 - https://rpm.newrelic.com/api/explore/alerts_location_failure_conditions/create
