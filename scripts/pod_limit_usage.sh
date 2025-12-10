#!/bin/bash

if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: $0 [MIN_PERCENT]"
    echo
    echo "Shows pods whose CPU or memory usage exceeds a given percentage of their limits."
    echo
    echo "MIN_PERCENT:"
    echo "    Optional. Show only pods where CPU% or MEM% exceed this value."
    echo "    Default: 0 (shows all pods)."
    echo
    echo "Example:"
    echo "    $0 10   # show pods using >=10% CPU or MEM"
    exit 0
fi

MIN_PERCENT=${1:-0}

echo -e "CPU%\tMEM%\tPOD"

# -----------------------------------------------------------
# Step 1: Collect CPU & MEM limits
# -----------------------------------------------------------
declare -A CPU_LIMITS
declare -A MEM_LIMITS

while read POD CPU_LIMIT MEM_LIMIT; do
    CPU_LIMITS["$POD"]="$CPU_LIMIT"
    MEM_LIMITS["$POD"]="$MEM_LIMIT"
done < <(
    oc get pods -o json | jq -r '
        .items[] |
        .metadata.name as $pod |
        # CPU limits (millicores)
        ([.spec.containers[].resources.limits.cpu // "0"]
            | map(if test("m$") then .[:-1] | tonumber else (tonumber * 1000) end)
            | add) as $cpu_limit |
        # MEM limits (MiB)
        ([.spec.containers[].resources.limits.memory // "0"]
            | map(
                if test("Mi$") then .[:-2] | tonumber
                elif test("Gi$") then (.[:-2] | tonumber) * 1024
                else 0 end
              )
            | add) as $mem_limit |
        "\($pod) \($cpu_limit) \($mem_limit)"
    '
)

# -----------------------------------------------------------
# Step 2: Collect CPU+MEM usage and filter
# -----------------------------------------------------------
declare -a FILTERED_PODS
declare -A CPU_PCT
declare -A MEM_PCT

while read POD CPU MEM; do
    # CPU to m
    if [[ "$CPU" == *m ]]; then
        CPU_M=${CPU%m}
    else
        CPU_M=$(awk "BEGIN {printf \"%d\", $CPU*1000}")
    fi

    # MEM to Mi
    if [[ "$MEM" == *Mi ]]; then
        MEM_MI=${MEM%Mi}
    elif [[ "$MEM" == *Gi ]]; then
        MEM_MI=$(awk "BEGIN {printf \"%d\", ${MEM%Gi}*1024}")
    else
        MEM_MI=0
    fi

    CPU_LIMIT="${CPU_LIMITS[$POD]}"
    MEM_LIMIT="${MEM_LIMITS[$POD]}"

    if [[ -z "$CPU_LIMIT" || "$CPU_LIMIT" == "0" ]]; then
        CPU_P=0
    else
        CPU_P=$(awk "BEGIN {printf \"%.4f\", ($CPU_M / $CPU_LIMIT) * 100}")
    fi

    if [[ -z "$MEM_LIMIT" || "$MEM_LIMIT" == "0" ]]; then
        MEM_P=0
    else
        MEM_P=$(awk "BEGIN {printf \"%.4f\", ($MEM_MI / $MEM_LIMIT) * 100}")
    fi

    # Filter: either CPU or MEM above threshold
    CMP=$(awk "BEGIN {print ($CPU_P >= $MIN_PERCENT || $MEM_P >= $MIN_PERCENT)}")

    if [[ "$CMP" -eq 1 ]]; then
        FILTERED_PODS+=("$POD")
        CPU_PCT["$POD"]="$CPU_P"
        MEM_PCT["$POD"]="$MEM_P"
    fi
done < <(oc adm top pod --no-headers | awk '{print $1" "$2" "$3}')

# -----------------------------------------------------------
# Step 3: Produce summary
# -----------------------------------------------------------
RESULTS=()
for POD in "${FILTERED_PODS[@]}"; do
    RESULTS+=("${CPU_PCT[$POD]} ${MEM_PCT[$POD]} $POD")
done

# -----------------------------------------------------------
# Step 4: Print sorted by CPU% desc
# -----------------------------------------------------------
printf "%s\n" "${RESULTS[@]}" \
  | sort -rn -k1 \
  | awk '{printf "%.2f%%\t%.2f%%\t%s\n", $1, $2, $3}'

