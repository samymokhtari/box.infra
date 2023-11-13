# Box Infrastructure
Box project infrastructure hosted on Google Cloud Platform

On-Premise infrastructure is hosted on a dedicated server.

OS Used: Debian 12

https://docs.docker.com/engine/swarm/stack-deploy/


## Setup Docker Containers

```bash
docker compose up -d -e MSSQL_SA_PASSWORD=pwd -e MARIADB_ROOT_USERNAME=username -e MARIADB_ROOT_PASSWORD=pwd --name box-db 
```

## Backup And Restore

https://mariadb.com/kb/en/container-backup-and-restoration/