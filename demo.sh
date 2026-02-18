#!/usr/bin/env bash
readonly START_TIME=$(date +%s%3N)

source ./logger.sh
logger_init

log INFO "This is an info message."
log WARN "This is a warning message."
log ERROR "This is an error message."
log DEBUG "This is a debug message."