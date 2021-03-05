# Docker 
## Build:
```shell script
docker build -t acolasz/postgres:13.0 \
  --build-arg db_name= \
  --build-arg db_user_name= \
  --build-arg db_user_psw= \
  --build-arg init_db_file= \
  .
```
## Start container
```shell script
docker run -d --name p-1 -v d:/workspace/github/Docker/postgre-sql-docker/data/${db_name}:/var/lib/postgresql/data -p 5444:5432 acolasz/postgres:13.0
```
### Exec
```shell script
docker exec -it p-1 psql -U ${db_user_name} ${db_name}
```
## Stop Container and Remove
```shell script
docker rm $(docker stop $(docker ps -aq --filter name=p-1))
```
### JDBC:
```shell script
jdbc:postgresql://localhost:5444/${db_name}
```
# Running pgAdmin container:
```shell script
docker run -p 7444:80 -e PGADMIN_DEFAULT_EMAIL=acolasz@postgres.local -e PGADMIN_DEFAULT_PASSWORD=acolasz --name pgadmin-1 -d dpage/pgadmin4
```
# DateBase example:
```postgresql
CREATE TABLE films (
    id          SERIAL PRIMARY KEY,
    title       varchar(40) NOT NULL
);
DROP TABLE films;
INSERT INTO films (title)
VALUES('The GodFather I.');
```
[Settup psAdmin4](https://towardsdatascience.com/local-development-set-up-of-postgresql-with-docker-c022632f13ea)
