#!/bin/bash
set -e -o pipefail -u
[ x"${DEBUG:-}" = "x1" ] && set -x

_get_policy_id () {
    local policy_name="$1"; shift

    local current_policies="$( newrelic_rest_cli get alerts policies | jq -e -r '.[][] | [ .name, .id | tostring ] | @tsv' )"
    [ -z "$current_policies" ] && echo "$0: Error: got no policies" && exit 1

    while read -r policy_name_id ; do
        [ -z "$policy_name_id" ] && break
        IFS=$'\t' read -ra pol <<< "$policy_name_id"
        if [ "${pol[0]}" = "$policy_name" ] ; then
            echo "${pol[1]}"
            return 0
        fi
    done <<<"$current_policies"
    return 1
}
_get_monitor_id () {
    local monitor_name="$1"
    shift
    local current_monitors="$( newrelic_synthetics_cli get monitors | jq -r '.monitors[] | [.name, .id, (.locations|length) | tostring] | @tsv' )"
    while read -r monitor ; do
        [ -z "$monitor" ] && break
        IFS=$'\t' read -ra mon <<< "$monitor"
        if [ "${mon[0]}" = "$monitor_name" ] ; then
            printf "${mon[1]}\t${mon[2]}\n"
            return 0
        fi
    done <<< "$current_monitors"
    return 1
}
_find_location_failure_condition () {
    local id="$1" condition_name="$2"
    shift 2
    local found_condition=0
    local conditions="$( newrelic_rest_cli get alerts location_failure_conditions "$id" \
        | jq -r '.location_failure_conditions[] | [ .name, .enabled, .id|tostring ] | @tsv' )"
    while read -r condition ; do
        [ -z "$condition" ] && break
        IFS=$'\t' read -ra cond <<< "$condition"
        if [ "${cond[0]}" = "$condition_name" ] ; then
            echo "${cond[2]}"
            found_condition=1
            break
        fi
    done <<< "$conditions"
    #[ $found_condition -eq 1 ] && return 0
    #return 1
}
_create_location_failure_condition () {
    local id="$1" condition_json="$2" condition_name="$3"
    shift 3
    echo "args $@"
    local location_len=0
    local -a mon_ids=()
    for monitor_name in "$@" ; do
        echo "looking up monitor name '$monitor_name'"
        local monitor_id_len="$( _get_monitor_id "$monitor_name" )"
        [ -z "$monitor_id_len" ] && break
        IFS=$'\t' read -ra mon <<< "$monitor_id_len"
        location_len=${mon[1]}
        mon_ids+=("${mon[0]}")
    done
    mon_id_string="$(printf "\"%s\", " "${mon_ids[@]}")"
    mon_id_string="${mon_id_string%, }"
    condname="\"$condition_name\""
    # Replace __THRESHOLD__ with the number of locations
    # Replace __SYNTHETIC_MONITOR_GUIDS__ with the IDs of the monitors to attach
    # Replace __CONDITION_NAME__ with the name for this condition
    condition_json="${condition_json/__THRESHOLD__/$location_len}"
    condition_json="${condition_json/__SYNTHETIC_MONITOR_GUIDS__/$mon_id_string}"
    condition_json="${condition_json/__CONDITION_NAME__/$condname}"
    echo "Creating a new location failure condition on policy '$id' with the following:"
    echo "$condition_json"
    newrelic_rest_cli create alerts location_failure_conditions "$POLICY_ID" "$condition_json"
}

# Looks for a specific policy and checks for multi-location failure conditions.
# If no failure condition exists, adds a failure condition to that policy.

if [ $# -lt 4 ] ; then
    echo "Usage: $0 POLICY_NAME POLICY_CONDITION_JSON CONDITION_NAME MONITOR_NAME [MONITOR_NAME ..]"
    echo ""
    echo "Looks up POLICY_NAME to see if it has a CONDITION_NAME location_failure_condition attached to it."
    echo "If it doesn't, it creates one using POLICY_CONDITION_JSON, attaching MONITOR_NAME to the condition"
    echo "and setting a threshold of the number of locations on the monitor (so, all of them)."
    exit 1
fi

POLICY_NAME="$1"
POLICY_CONDITION_JSON="$(cat "$2")"
CONDITION_NAME="$3"
shift 3

POLICY_ID="$(_get_policy_id "$POLICY_NAME")"

CONDITION_ID="$(_find_location_failure_condition "$POLICY_ID" "$CONDITION_NAME" )"
if [ -n "$CONDITION_ID" ] ; then
    echo "There is already a location failure condition '$CONDITION_NAME' (condition_id '$CONDITION_ID') attached to policy '$POLICY_NAME' (policy_id '$POLICY_ID')"
else
    echo "No failure condition '$CONDITION_NAME' is attached to policy '$POLICY_NAME' (id '$POLICY_ID'); creating it now"
    _create_location_failure_condition "$POLICY_ID" "$POLICY_CONDITION_JSON" "$CONDITION_NAME" "$@"
fi
