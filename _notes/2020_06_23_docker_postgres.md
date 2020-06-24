---
layout: projects 
title: Setting up Postgres for Docker 
mathjax: true
---

Setting up a docker container for Postgres, how fun! There are a few big issues that I have run into repeatedly when doing this. The first is that I _usually_ have Postgres running on the local machine which has already taken over the default port of 5432. To map this port differently, use the `ports` command. You also need to set up (1) a persistent volume outside the container and (2) the primary user credentials. At the end of the day, this is what my docker-compose service looks like for Postgres:

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

 
