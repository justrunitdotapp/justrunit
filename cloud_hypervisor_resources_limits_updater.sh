#!/bin/sh
set -e
CONTAINER_NAME="justrunit-cloud-hypervisor-1"
UPDATE_INTERVAL=${CH_UPDATE_INTERVAL:-60}

# Function to get total CPU cores
get_cpu_cores() {
    grep -c ^processor /proc/cpuinfo
}

# Function to get total memory in bytes
get_total_memory() {
    awk '/MemTotal/ {print $2 * 1024}' /proc/meminfo
}

# Main loop
while true; do
    # Get total CPU cores and memory
    total_cpu=$(get_cpu_cores)
    total_memory=$(get_total_memory)

    # Calculate 80% of total resources
    cpu_limit=$(echo "$total_cpu * 0.8" | bc)
    memory_limit=$(echo "$total_memory * 0.8" | bc | cut -d. -f1)

    echo "=== RESOURCES LIMIT UPDATE ==="
    echo "Updating container $CONTAINER_NAME"
    echo "Update interval: $UPDATE_INTERVAL seconds"    
    echo "CPU limit: $cpu_limit"
    echo "Memory limit: $memory_limit bytes"
    echo "=== END RESOURCES LIMIT UPDATE ==="
   
    # Update the container
    docker update --cpus $cpu_limit --memory $memory_limit --memory-swap $memory_limit $CONTAINER_NAME

    
    sleep $UPDATE_INTERVAL
done
