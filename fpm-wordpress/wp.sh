#!/bin/bash
set -e

su-exec www-data wp-cli.phar --color $*