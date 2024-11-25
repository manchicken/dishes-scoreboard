#!/usr/bin/env bash

cd ~/Devel/dishes-scoreboard

source ~/venv/inky/bin/activate
FLASK_APP=scoreboard FLASK_ENV=development flask run --host="$HOSTNAME.local" --port=5000
