
# 🗃️ cron Jobs Practice - Automated Backup Scripts

This repository is a structured collection of bash scripts for scheduling and managing backups using **cron jobs** in Unix-based systems. It includes organized folders for best practices, test routines, and real-world script variations.

---

## 📁 Repository Structure

```bash
cron-jobs/
│
├── best-practice/          # ✅ Recommended setup with .env and modular scripts
├── db-backup-routine/      # Database-specific backup experiments
├── echo-file/              # Basic test scripts using echo
├── multiple_db/            # Script to handle multiple DB backups
└── crontab.txt            # 🕒 Crontab example for scheduling backups
```

---

## ✅ `best-practice/` Folder (Primary Focus)

This folder contains modular and reusable bash scripts following best practices for:

- Structured backups (hourly, daily, weekly, etc.)
- Easy environment configuration
- Cleanup routines
- Directory initialization

### 📄 File Overview

| File Name              | Description |
|------------------------|-------------|
| `hourly_backup.sh`     | Performs hourly backups (every 3 hours) |
| `daily_backup.sh`      | Performs daily backups at midnight |
| `weekly_backup.sh`     | Runs every Sunday at midnight |
| `monthly_backup.sh`    | Executes on the first of each month |
| `yearly_backup.sh`     | Executes on January 1st |
| `cleanup_backups.sh`   | Deletes old backups beyond retention policy |
| `setup_backup_dirs.sh` | Initializes required backup folders |
| `laod_env.sh`          | Loads environment variables from `.env.backup` |
| `.env.backup.example`  | Example environment configuration file |
| `crontab.txt`         | Example crontab file for scheduling scripts |

---

## ⚙️ Setting Up the Environment

1. **Clone the Repository**
   ```bash
   git clone https://github.com/<your-username>/cron-jobs.git
   cd cron-jobs/best-practice
   ```

2. **Copy the example `.env` file**
   ```bash
   cp .env.backup.example .env.backup
   ```

3. **Edit `.env.backup` to match your system**
   ```env
   BACKUP_DIR="/path/to/backups"
   DB_HOST="localhost"
   DB_USER="your_user"
   DB_PASSWORD="your_password"
   DB_NAME="your_db"
   RETENTION_DAYS=7
   ```

4. **Set `ENV_FILE` in `laod_env.sh`**
   ```bash
   ENV_FILE="$(dirname "$0")/.env.backup"
   ```

---

## 📌 Usage Guide

Run any script manually or schedule via crontab.

### 🔄 Manual Execution

```bash
# Load env first
source ./laod_env.sh

# Example:
./hourly_backup.sh
./cleanup_backups.sh
```

### 🕒 Scheduling with Crontab

Open crontab:
```bash
crontab -e
```

Paste the contents from `crontab.txt`, and update `SCRIPT_PATH` to your absolute script directory path.

```cron
# Example with SCRIPT_PATH set
SCRIPT_PATH="/home/user/cron-jobs/best-practice"

0 */3 * * * $SCRIPT_PATH/hourly_backup.sh
0 0 * * * $SCRIPT_PATH/daily_backup.sh
0 0 * * 0 $SCRIPT_PATH/weekly_backup.sh
0 0 1 * * $SCRIPT_PATH/monthly_backup.sh
0 0 1 1 * $SCRIPT_PATH/yearly_backup.sh
0 1 * * * $SCRIPT_PATH/cleanup_backups.sh
```

---

## 🧪 Other Folders

### 📁 `db-backup-routine/`

Contains DB-focused backup scripts:
- `1 day.db.linux.sh`
- `script.linux.sh`
- `test.linux.sh`

These test out database dump techniques, compression, and rotation.

---

### 📁 `echo-file/`

Minimal test scripts:
- `script.linux.sh` and `script.window.sh` echo file contents.
- Useful for debugging crontab commands.

---

### 📁 `multiple_db/`

Single script handling multiple database backups:
- Uses loops and arrays to backup a list of databases.
- Ideal for multi-tenant systems.

---

## 💡 Pro Tips

- Make scripts executable:
  ```bash
  chmod +x *.sh
  ```

- View crontab logs (Linux):
  ```bash
  grep CRON /var/log/syslog
  ```

- Test environment sourcing:
  ```bash
  bash -x ./hourly_backup.sh
  ```

---

## 📂 Example: `.env.backup.example`

```env
# Path to store backup files
BACKUP_DIR="/var/backups/myapp"

# MySQL credentials
DB_HOST="localhost"
DB_USER="root"
DB_PASSWORD="secret"
DB_NAME="app_db"

# Retention policy
HOURLY_RETENTION=8
DAILY_RETENTION=7
WEEKLY_RETENTION=4
MONTHLY_RETENTION=12
YEARLY_RETENTION=5
```

---

## 🤝 Contributing

Feel free to fork and submit pull requests for improvements, new strategies, or enhancements in modularity and compatibility!

---

## 📜 License

This project is licensed under the MIT License.

---

## 👨‍💻 Author

**Ahad**  
Practicing automation with love ♥  
Happy Hacking : )

