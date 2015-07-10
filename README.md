# Wanamu Postgres Database

# Docker build command

docker build -t wanamudb .

# Docker run command

docker run --name wanamudb \
-p 5432:5432  \
-v /var/lib/postgresql/data:/var/lib/postgresql/data \
POSTGRES_PASSWORD=$POSTGRES_PASSWORD   \
POSTGRES_USER=$POSTGRES_USER \
-d wanamudb

# Update Wanamu DB
 To update the scheme of the wanamu db change the changelog.sql file
 The use our docker-liquibase image to update