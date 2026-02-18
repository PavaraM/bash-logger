#!/usr/bin/env bash

# ====================================================
# LOGGER FULL FEATURE DEMO
# ====================================================

set -euo pipefail

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly START_TIME=$(date +%s%3N)

# Load logger
source "$SCRIPT_DIR/lib/logger.sh"

# Initialize logger
logger_init

# ====================================================
# SECTION 1: Basic Log Levels
# ====================================================

log INFO  "Demo started in environment: $environment"
log DEBUG "This debug message should only show if MIN_LOG_LEVEL=DEBUG"
log INFO  "Standard informational message"
log WARN  "This is a warning message"
log ERROR "This is an error message"

# ====================================================
# SECTION 2: Variable Logging
# ====================================================

sample_variable="docker"
log INFO "Testing variable interpolation: service=$sample_variable"

# ====================================================
# SECTION 3: Simulated Process Timing
# ====================================================

log INFO "Simulating workload..."
sleep 1
log DEBUG "Halfway through simulated workload..."
sleep 1
log INFO "Workload completed"

# ====================================================
# SECTION 4: Command Execution Example
# ====================================================

log INFO "Running sample command: uname -a"
if output=$(uname -a 2>&1); then
    log INFO "Command succeeded"
    log DEBUG "Command output: $output"
else
    log ERROR "Command failed: $output"
fi

# ====================================================
# SECTION 5: Log Level Filtering Demonstration
# ====================================================

log INFO "If MIN_LOG_LEVEL is set to WARN, you should not see this INFO"
log DEBUG "If MIN_LOG_LEVEL is WARN or ERROR, you should not see this DEBUG"

# ====================================================
# SECTION 6: Simulated Error Exit
# ====================================================

log WARN "Demo script will now exit with code 0 to show footer behavior"

# Footer will auto-run via trap
exit 0
