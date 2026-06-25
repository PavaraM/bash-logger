# bash-logger

A lightweight, reusable logging library for Bash scripts.

---

## Features

- Four log levels: `DEBUG`, `INFO`, `WARN`, `ERROR`
- Colored console output
- File logging with timestamps
- Automatic log archiving based on retention days
- Script duration and exit code footer in log files
- `sudo`-aware file ownership handling (no load-time side effects)
- Configurable via a simple `.conf` file
- Invalid `MIN_LOG_LEVEL` falls back to `INFO` with a warning

---

## Project Structure

```
your-project/
├── conf/
│   └── logger.conf
├── lib/
│   └── logger.sh
└── your-script.sh
```

---

## Setup

1. Copy `lib/logger.sh` and `conf/logger.conf` into your project following the structure above.

2. Source the library:

```bash
source ./lib/logger.sh
```

   `SCRIPT_DIR` is auto-detected from the library location, so no need to set it manually. You can still override it if needed:

```bash
readonly SCRIPT_DIR="/path/to/your/project"
source "$SCRIPT_DIR/lib/logger.sh"
```

   For accurate duration tracking in the footer, set `START_TIME` **before** sourcing the library:

```bash
readonly START_TIME=$(date +%s%3N)
```

   If omitted, the footer shows `N/A` for duration.

3. Initialize the logger before any `log` calls:

```bash
logger_init
```

   `logger_init` creates the log file, runs archiving, and registers a trap to automatically write the footer when the script exits. You do not need to call `log_footer` manually.

---

## Configuration

All settings live in `conf/logger.conf`.

| Variable | Description | Example |
|---|---|---|
| `softname` | Name used in log filenames | `myapp` |
| `environment` | Environment tag in log filenames | `dev`, `prod` |
| `LOG_DIR` | Directory for log files | `$SCRIPT_DIR/logs` |
| `ARCHIVE_DIR` | Directory for archived logs | `$SCRIPT_DIR/logs/archive` |
| `LOG_RETENTION_DAYS` | Days before logs are archived | `7` |
| `MIN_LOG_LEVEL` | Minimum level to output | `DEBUG`, `INFO`, `WARN`, `ERROR` |
| `SHOW_CONSOLE` | Print logs to terminal | `true` / `false` |
| `SHOW_FILE` | Write logs to file | `true` / `false` |
| `ENABLE_COLORS` | Colorize console output | `true` / `false` |
| `AUTO_ARCHIVE` | Automatically archive old logs | `true` / `false` |
| `AUTO_CHOWN` | Fix log ownership when using sudo | `true` / `false` |
| `LOG_DATE_FORMAT` | Timestamp format | `%Y-%m-%d %H:%M:%S` |
| `COLOR_DEBUG` | ANSI color for DEBUG | `\033[0;34m` |
| `COLOR_INFO` | ANSI color for INFO | `\033[0;32m` |
| `COLOR_WARN` | ANSI color for WARN | `\033[1;33m` |
| `COLOR_ERROR` | ANSI color for ERROR | `\033[0;31m` |
| `COLOR_RESET` | ANSI reset code | `\033[0m` |

> **Note:** If `MIN_LOG_LEVEL` is set to an invalid value, the library prints a warning to stderr and falls back to `INFO`.

---

## Usage

```bash
log DEBUG "Detailed diagnostic info"
log INFO  "Service started on port 8080"
log WARN  "Disk usage above 80%"
log ERROR "Failed to connect to database"
```

Log level input is case-insensitive — `log info "message"` and `log INFO "message"` both work.

Log level filtering is controlled by `MIN_LOG_LEVEL`. For example, setting it to `WARN` will suppress `DEBUG` and `INFO` messages.

---

## Log Files

Log files are created automatically in `LOG_DIR` and named:

```
{softname}_{environment}_{YYYY-MM-DD}.log
```

For example: `sample_dev_2026-02-18.log`

Each log file includes a header on start and a footer on exit containing the timestamp, exit code, and total script duration.

---

## License

MIT
