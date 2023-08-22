---
layout: notes 
title: Setting up Postgres for Docker 
date: August 20th, 2023
mathjax: true
---

Setting up a docker container for Postgres, how fun! There are a few issues that I have run into repeatedly when doing this. The first is that I _usually_ have Postgres running on the local machine which has already taken over the default port of 5432. To map this port differently, use the `ports` command. You also need to set up (1) a persistent volume outside the container and (2) the primary user credentials. At the end of the day, this is what my docker-compose service looks like for Postgres:

```
    db:
      image: postgres
      ports: 
        - "5433:5432"
      environment:
        - POSTGRES_DB=postgres
        - POSTGRES_USER=postgres
        - POSTGRES_PASSWORD=postgres
      networks:
        - bridgenetwork
      volumes:
        - ./postgres-data:/var/lib/postgresql/data
```

This assumes that you want the default db/user/password to be `postgres` and you have a directory, outside the container and in the current directory called `postgres-data` which will be mapped into the container to the place where Postgres stores it data (`/var/lib/postgresql/data`).

Oh, and your default network is called `bridgenetwork`

Now, what if you want a different docker container (_not_ part of this docker compose file) to use this container? For example, I usually run my local PostgresSQL through docker and now have a different project that wants to access it? 

The key is to change the `host` on the machine that wants to access the PostgresSQL container to `host = 'host.docker.internal'`. The example below would be able to connect to the database above since it uses the default port of 5432.

```
    host = 'host.docker.internal'
    user_name = 'postgres'
    password = 'postgres'
    dbname = 'postgres'

    conn_string = "host='%s' dbname='%s' user='%s' password='%s'" % (host, dbname, user_name, password)
    postgres_conn = psycopg2.connect(conn_string)

```


 
