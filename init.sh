#
#	INIT SCRIPT INSPIRED/SNAGGED FROM https://github.com/beevelop/docker-directus/blob/master/init.sh
#
#!/bin/bash
set -ea

DB_PORT=${DB_PORT:-3306}

while ! nc -z ${DB_HOST} ${DB_PORT}; do
	echo "Waiting for Database ${DB_HOST}:${DB_PORT}..."
	sleep 2
done

if ! $(wp core is-installed); then
	if [ -n "$ADMIN_USER" ] && [ -n "$ADMIN_PASS" ] && [ -n "$ADMIN_EMAIL" ] && [ -n "$SITE_TITLE" ]; then
		echo "You've given me install info. I guess I should use it. Installing..."
		sync # see: https://github.com/docker/docker/issues/9547

		wp core install \
			--title=${SITE_TITLE} \
			--admin_user=${ADMIN_USER} \
			--admin_password=${ADMIN_PASS} \
			--admin_email=${ADMIN_EMAIL} \
			--url=${WP_HOME} \
			--skip-email
	fi
fi