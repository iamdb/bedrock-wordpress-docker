# Dockerized Wordpress using Bedrock

* Wordpress install based on [Bedrock](https://github.com/roots/bedrock).
* Create a fresh install or bring your own.
* [wp-cli](https://wp-cli.org) support
* Increased security out of the box.
* Utilizes [custom nginx config](https://github.com/perusio/wordpress-nginx).
* php 7.0, mariadb 10.1 and nginx 1.10

This is meant to be a starting off point. A way to quickly get a highly configured, as close to production-ready Wordpress install up and running very quickly while providing a flexible way of handling site files (plugins, themes, etc.) and creating consistent installations across servers. This is meant to be a tool, not a solution. It's also my tool, so it's pretty opinionated at the moment, but I'm open to ideas, suggestions. A lot of this is pieced together from great work done by others as noted in the files.

It's not ideal as a development environment. I think using the wp-cli server (which is just the built-in php server) and a [Homebrew](http://brew.sh/) managed mysql database is still ideal for fast development. You can test builds in it locally, though, which should give a good indication of how it will run in production.

It assumes you're familiar with [docker-machine](https://docs.docker.com/machine/overview/) and [docker-compose](https://docs.docker.com/compose/overview/).

It can be used/configured in a variety of ways:

* You can mount your own volume and replace the entire Bedrock installation at `/var/www/html/` with your own.
* You can just mount the `web/app` folder with your plugins, themes and uploads and let the container deal with Wordpress.
* You can make a custom dockerized Wordpress installation by forking this repo or by using `iamdb/fpm-bedrock-wordpress` as a starting image and managing your install using composer (example below).

The `nginx` and `fpm` containers are provided separately for flexibility, but there's a sample `docker-compose.yml` file that's provided which should have everything you need to get up and running quickly. They are also built automatically on Docker Hub using this repo at `iamdb/nginx-bedrock-wordpress` and `iamdb/fpm-bedrock-wordpress`.

## docker-compose.yml
Change the `WP_HOME` and `WP_SITEURL` variables to your values. Add an admin username, password and email and a site title as shown in the `docker-compose.yml` file to create a fresh install.

From there, just:
```
docker-compose up
```

It will build and start all of the containers. It may take a while the first time. The `fpm` container has a lot to build. If they all build and start correctly, the `fpm` container will wait for the database host and port to become available. Once it is, and if Wordpress isn't already installed and all of the admin variables and the site title variable are present, a new installation using that information will be created. If that information is not provided, you can run the same install cammand using wp-cli commands.

## wp-cli

Once you have everything up and running, it's as simple as the below to run wp-cli commands.
```
docker exec fpm wp core version
```

## Using as a base image

The `iamdb/fpm-bedrock-wordpress` image is designed to be used as a base image as well. This makes it easy to build and rebuild containers that have everything your Wordpress installation needs, every single time.

Sample custom fpm Dockerfile:
```
FROM iamdb/fpm-bedrock-wordpress

RUN su-exec www-data composer require \
	wpackagist-plugin/akismet \
	wpackagist-plugin/captcha \
	&& composer install
```

## A note about the nginx configuraiton

It makes all urls that end in `install.php` as well as the `readme.html` require a password. This is done for security reasons. This does not currently create a password. All core, plugin and theme installations must be done by making a new base image or through a wp-cli command.

You can disable the password by providing an `ALLOW_INSTALL` environment variable with a string value of `yes`. You can see an example of this in the `docker-compose.yml` file.

## Goals

* Let's Encrypt support
* S3 support
* [dictator](https://github.com/danielbachhuber/dictator) support