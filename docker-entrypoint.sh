#!/bin/sh

set -e

case $1 in

  web)
    exec bundle exec puma -C config/puma.rb
  ;;

  sidekiq)
    exec bundle exec sidekiq -C config/sidekiq.yml
  ;;

  *)
    exec "$@"
  ;;

esac

exit 0
