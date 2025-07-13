# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 言語設定 / Language Settings

**重要**: このプロジェクトでのすべてのやり取りは日本語で行ってください。技術用語は必要に応じて英語を併記しても構いませんが、説明は日本語で行ってください。

## Project Overview

This is an Ubuntu 24.10 DevContainer project that provides a development environment with:
- Ubuntu 24.10 base image
- MySQL 8.0 database service
- Python 3 with pip
- Node.js LTS (via nvm)
- PHP and Composer
- Various development tools and CLI utilities

## Architecture

### Container Structure
The project uses Docker Compose with two services:
1. **devcontainer**: Main development container running Ubuntu 24.10
   - Mounts the parent directory to `/workspace`
   - Has Docker socket access for Docker-in-Docker operations
   - Runs with privileged mode

2. **ubuntu_mysql**: MySQL 8.0 database container
   - Accessible on port 3306
   - Default database: `laravel`
   - Default user: `laravel` (password: `laravel`)
   - Root password: `root`

### Directory Structure
```
/workspace/devcontainer_ubuntu/
├── .devcontainer/       # DevContainer configuration
│   └── logs/           # DevContainer setup logs
├── docker/              # Docker configuration files
│   ├── Dockerfile      # Ubuntu 24.10 base image setup
│   ├── motd.sh        # Message of the day script
│   ├── mysql/         # MySQL configuration
│   │   └── conf.d/    # MySQL custom configuration
│   └── logs/          # Docker service logs
│       └── mysql/     # MySQL logs
├── docker-compose.yml   # Container orchestration
├── postCreateCommand.sh # Initial setup script (runs once)
└── postStartCommand.sh  # Startup script (runs on each start)
```

## Common Commands

### Container Management
```bash
# Start the containers
docker-compose up -d

# View container logs
docker-compose logs -f

# Access the devcontainer shell
docker exec -it ubuntu bash

# Stop containers
docker-compose down
```

### Database Access
```bash
# Connect to MySQL from devcontainer
mysql -h ubuntu_mysql -u laravel -plaravel laravel

# Connect as root
mysql -h ubuntu_mysql -u root -proot
```

### Log Locations
- DevContainer setup logs: `/workspace/devcontainer_ubuntu/.devcontainer/logs/setup.log`
- MySQL logs: `/workspace/devcontainer_ubuntu/docker/logs/mysql/`

## Important Notes

1. **Package Management**: The Dockerfile contains only essential packages. Development tools are installed via postCreateCommand.sh to keep the base image minimal and flexible.

2. **Volume Mounts**: The docker-compose.yml maps:
   - `./.devcontainer/logs:/var/log/devcontainer` for devcontainer logs
   - `./docker/logs/mysql:/var/log/mysql` for MySQL logs

3. **MySQL Configuration**: Custom MySQL configuration is mounted from `./docker/mysql/conf.d/custom.cnf`

4. **User Context**: The container runs as `ubuntu` (UID 1000) with sudo privileges

5. **Development Environment**: 
   - Node.js LTS is installed via nvm in postCreateCommand.sh
   - PHP, Composer, and other tools are installed during container initialization
   - Python packages are installed per user

6. **CLI Tools**: Various development CLI tools including Claude Code CLI are installed if available

## Development Workflow

1. **Initial Setup**: Run `docker-compose up -d` to start containers
2. **Development**: Access the container and work in `/workspace`
3. **Database**: Use the MySQL service for database-related development
4. **Logging**: Check setup logs if issues occur during initialization

## Data Analysis Tools

This repository includes Python-based financial asset analysis tools:

### Core Analysis Scripts
- **asset_analysis.py**: Advanced visualization using pandas/matplotlib with Japanese font support
- **simple_analysis.py**: Lightweight CSV analysis with JSON output
- **資産管理 - 資産推移.csv**: Time-series asset data (Feb 2020 - Jun 2025)

### Common Commands
```bash
# Run data analysis
python3 asset_analysis.py          # Generate charts and detailed analysis
python3 simple_analysis.py         # Basic analysis with JSON output

# View results
cat analysis_results.json          # Check analysis output
ls *.png                          # View generated charts
```

### Python Environment
Required packages are auto-installed via postCreateCommand.sh:
- pandas, numpy, matplotlib (data analysis)
- requests, pytest, black, flake8 (development tools)