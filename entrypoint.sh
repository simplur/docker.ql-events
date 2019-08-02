#!/bin/bash

# Run WordPress docker entrypoint.
. docker-entrypoint.sh 'apache2'

set +u

# Ensure mysql is loaded
dockerize -wait tcp://${DB_HOST}:${DB_HOST_PORT:-3306} -timeout 1m

# Config WordPress
if [ ! -f "${WP_ROOT_FOLDER}/wp-config.php" ]; then
    wp config create \
        --path="${WP_ROOT_FOLDER}" \
        --dbname="${DB_NAME}" \
        --dbuser="${DB_USER}" \
        --dbpass="${DB_PASSWORD}" \
        --dbhost="${DB_HOST}" \
        --dbprefix="${WP_TABLE_PREFIX}" \
        --skip-check \
        --quiet \
        --allow-root
fi

# Install WP if not yet installed
if ! $( wp core is-installed --allow-root ); then
	wp core install \
		--path="${WP_ROOT_FOLDER}" \
		--url="${WP_URL}" \
		--title='Test' \
		--admin_user="${ADMIN_USERNAME}" \
		--admin_password="${ADMIN_PASSWORD}" \
		--admin_email="${ADMIN_EMAIL}" \
		--allow-root
fi

# Install and activate WooCommerce
if [ ! -f "${PLUGINS_DIR}/the-events-calendar/the-events-calendar.php" ]; then
	wp plugin install the-events-calendar --activate --allow-root
fi

# Install and activate WooCommerce
if [ ! -f "${PLUGINS_DIR}/event-tickets/event-tickets.php" ]; then
	wp plugin install event-tickets --activate --allow-root
fi

# Install and activate WPGraphQL
if [ ! -f "${PLUGINS_DIR}/wp-graphql/wp-graphql.php" ]; then
    wp plugin install \
        https://github.com/wp-graphql/wp-graphql/archive/master.zip \
        --activate --allow-root
fi

# Install and activate WPGraphQL JWT Authentication
if [ ! -f "${PLUGINS_DIR}/wp-graphql-jwt-authentication/wp-graphql-jwt-authentication.php" ]; then
    wp plugin install \
        https://github.com/wp-graphql/wp-graphql-jwt-authentication/archive/master.zip \
        --activate --allow-root
fi

# Install and activate WPGraphiQL
if [[ ! -z "$INCLUDE_WPGRAPHIQL" ]]; then
    if [ ! -f "${PLUGINS_DIR}/wp-graphiql/wp-graphiql.php" ]; then
        wp plugin install \
            https://github.com/wp-graphql/wp-graphiql/archive/master.zip \
            --activate --allow-root
    fi
fi

# Install and activate WooGraphQL
if [ ! -f "${PLUGINS_DIR}/ql-events/ql-events.php" ]; then
    wp plugin install \
        https://github.com/simplur/ql-events/archive/${QL_EVENTS_BRANCH:-master}.zip \
        --activate --allow-root
else
    wp plugin activate ql-events --allow-root
fi

# Set pretty permalinks.
wp rewrite structure '/%year%/%monthnum%/%postname%/' --allow-root

wp db export "${PROJECT_DIR}/tests/_data/dump.sql" --allow-root

exec "$@"