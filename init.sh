#!/bin/bash

set -e -u

python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt

if [[ "$FLASK_ENV" == "development" ]]; then
  flask run
else
  # Production
  nohup /usr/local/bin/uwsgi --uid 1000 --gid 1000 --ini app.ini 2>&1 > /dev/stdout &
  /usr/sbin/nginx -g 'daemon off;'
fi
