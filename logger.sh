# ====================================================
# LOGGER - BASH UTILS
# logging library for bash scripts
# ----------------------------------------------------
# Authour: Pavara Mirihagalla
# ====================================================
# ====================================================
# INITIAL VARIABLES
# ----------------------------------------------------
readonly TIMESTAMP=$(date '+%Y-%m-%d')
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# ====================================================


# ====================================================
# PULL CONFIG
# ----------------------------------------------------
source ./logger.conf
# ====================================================


# ====================================================
# Set ownership of logs to the invoking user if running with sudo
if [[ -n "${SUDO_USER:-}" ]]; then
    chown -R "$SUDO_USER:$SUDO_USER" "$SCRIPT_DIR/logs/"
fi
# =====================================================

# ====================================================
# DIRECTORY CREATION
# ----------------------------------------------------
mkdir -p "$SCRIPT_DIR/logs/"
mkdir -p "$SCRIPT_DIR/logs/archive/"
# ====================================================

# ====================================================
# ARCHIVE LOGS
# ----------------------------------------------------
find "$SCRIPT_DIR/logs/" -type f -name "devbox_*.log" -mtime +7 -exec mv {} "$SCRIPT_DIR/logs/archive/" \;
# ====================================================

# ====================================================
# INITIALIZE LOG FILE
# ----------------------------------------------------
touch "$logfile"
echo "script started at $(date)" >> "$logfile"
echo "command: $softname $@" >> "$logfile"
echo "system: $(uname -a)" >> "$logfile"
echo "shell: $SHELL" >> "$logfile"
echo "SCRIPT_DIR: $SCRIPT_DIR" >> "$logfile"
echo "user: $USER (SUDO_USER: ${SUDO_USER:-none})" >> "$logfile"
echo "------------------------------" >> "$logfile"
echo " " >> "$logfile" 
# ====================================================

# ====================================================
# SET OWNERSHIP OF NEW LOG FILE TO INVOKING USER IF RUNNING WITH SUDO
if [[ -n "${SUDO_USER:-}" ]]; then
    chown "$SUDO_USER:$SUDO_USER" "$logfile"
fi
# ====================================================

# ====================================================
# PARSE LOG LEVEL
# ----------------------------------------------------
log_level() {
        case "$1" in
        INFO|info|i)
        levelsort="INFO"
        olor=$GREEN
        ;;
        WARN|warn|w)
        levelsort="WARN"
        color=$RED
        ;;
        ERROR|error|e)
        levelsort="ERROR"
        color=$RED
        ;;
        DEBUG|debug|d)
        levelsort="DEBUG"
        color=$BLUE
        ;;

        *)
        levelsort="OTHER"
        color=$NC
        ;;
    esac

}
# ====================================================
# LOGGING FUNCTION
# ----------------------------------------------------
log() {
    local level=$1
    shift
    log_level "$level"
    local levelline="${color}$levelsort${NC}"
    local line="$(date +%Y-%m-%d' '%H:%M:%S) [$levelline] $*"
    local line_nc="$(date +%Y-%m-%d' '%H:%M:%S) [$level] $*"

    if [ "$show_log_inconsole" = true ]; then
    echo "$line"
    fi
    echo "$line_nc" >> "$logfile"
}