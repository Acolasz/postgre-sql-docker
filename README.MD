## Source Clone:

## Docker 
### Build:
```shell script
docker build -t acolasz/postgres:1.0.0 .
```
## Start container
```shell script
docker run -d --name p-1 -v d:/workspace/github/Docker/postgresql/custom:/var/lib/postgresql/data -p 5444:5432 acolasz/postgres:1.0.0
```
### JDBC:
```shell script
jdbc:postgresql://localhost:5444/first
```
###Running pgAdmin container:
```shell script
docker run -p 7070:80 -e PGADMIN_DEFAULT_EMAIL=acolasz@postgres.local -e PGADMIN_DEFAULT_PASSWORD=acolasz --name pgadmin-1 -d dpage/pgadmin4
```
[Settup psAdmin4](https://towardsdatascience.com/local-development-set-up-of-postgresql-with-docker-c022632f13ea)
