#!/usr/bin/env bash
readonly START_TIME=$(date +%s%3N)

source ./logger.sh
logger_init

log i "This is an info message."
log w "This is a warning message."
log e "This is an error message."
log d "This is a debug message."