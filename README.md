# Wanamu Postgres Database

# Docker build command

docker build -t wanamudb .

# Docker run command

docker run --name wanamudb \
-p 5432:5432  \
-v POSTGRES_DATA:/var/lib/postgresql/data \
-e POSTGRES_PASSWORD=$POSTGRES_PASSWORD   \
-e POSTGRES_USER=$POSTGRES_USER \
-e DB_USER=$WU_DB_USER
-e DB_PASS=$WU_DB_PASS
-e DB_NAME=$WU_DB_NAME
-d wanamudb


## Explanation
<table>
 <tr>
  <td>POSTGRES_DATA</td>
  <td>Host Folder to map the postgres data from inside the container</td>
 </tr>
 <tr>
  <td>POSTGRES_USER</td>
  <td>Superuser of the db with create and drop permission</td>
 </tr>
  <tr>
   <td>POSTGRES_PASSWORD</td>
   <td>Password of superuser</td>
  </tr>
   <tr>
     <td>DB_USER, DB_PASS, DB_NAME</td>
     <td>Name of the wanamu database, user and password. Defaults to wanamu dont use this in production</td>
    </tr>
</table>

# Update Wanamu DB
 To update the scheme of the wanamu db change the changelog.sql file
 The use our docker-liquibase image to update the database
 
 https://bitbucket.org/schnueggel/docker-liquibase
 

docker run --name liquibase --link wanamudb:db \

 -v $LIQUIBASE_CHANGELOGS:/changelogs \
 
 -e CHANGELOG_FILE=$LB_CHANGELOG_FILE \
 
 -e DB_NAME=wanamu --rm -it liquibase update

## Explanantion
<table>
 <tr>
  <td>$LIQUIBASE_CHANGELOGS</td>
  <td>Changelog folder on the host</td>
 </tr>
 <tr>
  <td>$LB_CHANGELOG_FILE</td>
  <td>Changelog file on the host that should be applied to the database. This file should reside in /changelogs inside the container and must be in $LB_CHANGELOGS folder</td>
 </tr>

</table>

# See

Postgres Docker - https://registry.hub.docker.com/_/postgres/
