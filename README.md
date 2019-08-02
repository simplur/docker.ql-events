# Docker Build - QL Events App
Pre-configured WordPress installation w/ QL Events and all necessary dependencies.
*This image is hosted on [Docker Hub](https://hub.docker.com/r/kidunot89/ql-events-app)*

## Required Environment Variables.
- **DB_HOST** - Database host
- **DB_NAME** - Database name
- **DB_USER** - Database user
- **DB_PASSWORD** - Database password
- **WP_TABLE_PREFIX** - WordPress table prefix
- **WP_URL** - WordPress site url
- **ADMIN_USERNAME** - WordPress admin username
- **ADMIN_PASSWORD** - WordPress admin password
- **ADMIN_EMAIL** - WordPress admin email

## Optional Environment Variables.
- **INCLUDE_WPGRAPHIQL** - Whether or not to install and activate the [WPGraphiQL](https://github.com/wp-graphql/wp-graphiql) plugin.
- **QL_EVENTS_BRANCH** - QL Events target branch. *Ex. release-v0.2.0, develop, master, ...etc*

## Example `docker-compose.yml`
```
version: '3.3'

services:
  app:
    depends_on:
      - app_db
    image: "kidunot89/woographql-app:wp${WP_VERSION:-5.2.2}-php${PHP_VERSION:-7.2}"
    volumes:
      - '.:/var/www/html/wp-content/plugins/ql-events'
      - './.log/app:/var/log/apache2'
    env_file: .env
    environment:
      DB_NAME: wordpress
      DB_HOST: app_db
      DB_USER: wordpress
      DB_PASSWORD: wordpress
      WP_TABLE_PREFIX: 'wp_'
      WP_URL: 'http://localhost:8001'
      ADMIN_USERNAME: admin
      ADMIN_PASSWORD: password
      ADMIN_EMAIL: 'admin@example.com'
      INCLUDE_WPGRAPHIQL: 1
      QL_EVENTS_BRANCH: 'master'
    ports:
      - '8081:80'
    networks:
      local:

  app_db:
    image: mysql:5.7
    environment:
      MYSQL_ROOT_PASSWORD: root
      MYSQL_DATABASE:      wordpress
      MYSQL_USER:          wordpress
      MYSQL_PASSWORD:      wordpress
    ports:
      - '3306'
    networks:
      local:

networks:
  local:
```