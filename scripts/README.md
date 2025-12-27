# Scripts Directory

This directory contains bash scripts for the project.

## Naming Convention

- `cont_*.sh` - Scripts that run **INSIDE** the container
- `ext_*.sh` - Scripts that run on the **HOST** system

## Examples

```bash
# Container script (run inside container)
cont_install_deps.sh
cont_run_migrations.sh

# External/Host script (run on host)
ext_deploy.sh
ext_backup.sh
```

## Running Scripts

### Inside Container
```bash
docker exec -it ${PROJECT_NAME}_dev bash /var/scripts/cont_example.sh
```

### On Host
```bash
./scripts/ext_example.sh
```
