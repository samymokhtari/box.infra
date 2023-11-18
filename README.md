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

## Setting up SSL certificate for nginx webserver

https://mindsers.blog/en/post/https-using-nginx-certbot-docker/

```bash
sudo docker compose run --rm  certbot certonly --webroot --webroot-path /var/www/certbot/ -d example.com -d 'box.example.com' --cert-name example.com
```