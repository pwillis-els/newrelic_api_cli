#!/usr/bin/env bash

set -x

# This file is a JSON document to be passed to the
# 'newrelic_rest_cli create alerts location_failure_conditions' command.
# The ./apply_multi_location_failure_condition.sh script will replace
# specific values in the JSON document on the fly.
POLICY_CONDITION_JSON_TEMPLATE="synthetic-multi-location-health-check.json.tmpl"

# The generic condition name to use for each condition created
CONDITION_NAME="Multiple location failure"

# This greps for policies with "-syn", meaning "synthetics", in the name
mapfile -t policies_current < <(newrelic_rest_cli get alerts policies | jq -r .policies[].name | grep -e "-syn$" | sort)
mapfile -t monitors_current < <(newrelic_synthetics_cli get monitors | jq -r .monitors[].name | sort)

if [ ${#policies_current[@]} -ne ${#monitors_current[@]} ] ; then
    echo "$0: Error: number of policies and number of monitors does not match! Exiting"
    exit 1
fi

c=0
while [ $c -lt ${#policies_current[@]} ] ; do
    echo "Applying the multi-location failure condition to policy '${policies_current[$c]}', monitor '${monitors_current[$c]}'"
    apply_multi_location_failure_condition.sh \
        "${policies_current[$c]}" \
        "$POLICY_CONDITION_JSON_TEMPLATE" \
        "$CONDITION_NAME" \
        "${monitors_current[$c]}"
    c=$(($c+1))
done
