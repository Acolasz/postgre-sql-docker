FROM postgres:13.0

ARG db_name
ARG db_user_name
ARG db_user_psw
ARG init_db_file

ENV LANG en_US.UTF-8
ENV PGDATA=/var/lib/postgresql/data/pgdata
ENV POSTGRES_DB=${db_name}
ENV POSTGRES_USER=${db_user_name}
ENV POSTGRES_PASSWORD=${db_user_psw}

RUN localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

#ADD sql/${init_db_file} /docker-entrypoint-initdb.d

EXPOSE 5432
