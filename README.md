# Wanamu Postgres Database

# Docker build command

docker build -t wanamu/wanamudb .

# Docker run command
Use the start.sh script to start the database

Usage: [postgres super user] [postgres super password] [wanamudb user] [wanamudb password] [wanamudb image]

Example:./start.sh postgres postgres  wanamu wanamu wanamu/wanamudb


# Update Wanamu DB
To update the scheme of the wanamu db change the changelog1.xml file or add a new log file
The use our docker-liquibase image to update the database

see:

https://bitbucket.org/schnueggel/docker-liquibase
# Dump data

Use the dump script to make a data dump
# See

Postgres Docker - https://registry.hub.docker.com/_/postgres/
