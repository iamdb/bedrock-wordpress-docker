#!/bin/sh

if [ -n "$ALLOW_INSTALL" ] && [ "$ALLOW_INSTALL" == "yes" ]; then
	sed -i "s|auth_basic|# auth_basic|g" /etc/nginx/sites-enabled/default.conf
	sed -i "s|auth_basic_user_file|# auth_basic_user_file|g" /etc/nginx/sites-enabled/default.conf
fi