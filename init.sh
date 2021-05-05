#!/bin/bash

set -e -u

pip install -r requirements.txt

if [[ "$FLASK_ENV" == "development "]]; then
  flask run --host 0.0.0.0 --port 80
else
  # Production
  nohup /usr/local/bin/uwsgi --uid 1000 --gid 1000 --ini app.ini 2>&1 > /dev/stdout &
  /usr/sbin/nginx -g 'daemon off;'
fi
