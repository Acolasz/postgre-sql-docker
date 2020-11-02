FROM postgres:13.0

ENV LANG de_DE.utf8
ENV PGDATA=/var/lib/postgresql/data/pgdata
ENV POSTGRES_DB=first
ENV POSTGRES_USER=admin
ENV POSTGRES_PASSWORD=admin

RUN localedef -i de_DE -c -f UTF-8 -A /usr/share/locale/locale.alias de_DE.UTF-8

ADD sql/init-user-db.sh /docker-entrypoint-initdb.d

EXPOSE 5432