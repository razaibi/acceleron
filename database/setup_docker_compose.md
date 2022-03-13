Create a docker-compose.yml.

```docker
version: '3.8'
services:
  db:
    image: postgres:14.1-alpine
    restart: always
    environment:
      - POSTGRES_USER=<postgres-username
      - POSTGRES_PASSWORD=<postgres-password>
    ports:
      - '5432:5432'
    volumes: 
      - db:/var/lib/postgresql/data
volumes:
  db:
    driver: local
```

Execute using:

```
docker-compose up
```
