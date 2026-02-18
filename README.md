# bash-logger

A lightweight, reusable logging library for Bash scripts.

---

## Features

- Four log levels: `DEBUG`, `INFO`, `WARN`, `ERROR`
- Colored console output
- File logging with timestamps
- Automatic log archiving based on retention days
- Script duration and exit code footer in log files
- `sudo`-aware file ownership handling
- Configurable via a simple `.conf` file

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
2. In your script, set `SCRIPT_DIR` and source the library:

```bash
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/logger.sh"
```

3. Initialize the logger before any `log` calls:

```bash
logger_init
```

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

---

## Usage

```bash
log DEBUG "Detailed diagnostic info"
log INFO  "Service started on port 8080"
log WARN  "Disk usage above 80%"
log ERROR "Failed to connect to database"
```

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