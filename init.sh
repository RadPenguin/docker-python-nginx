#!/bin/bash

set -e -u


if [[ "$FLASK_ENV" == "development" ]]; then
  python3 -m venv .venv
  source .venv/bin/activate
  pip install -r requirements.txt
  flask run
else
  # Production
  source .venv/bin/activate
  nohup /app/.venv/bin/uwsgi --uid 1000 --gid 1000 --ini app.ini 2>&1 > /dev/stdout &
  /usr/sbin/nginx -g 'daemon off;'
fi
