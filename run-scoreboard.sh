#!/usr/bin/env bash
cd /home/manchicken/Devel/dishes-scoreboard

source ~/venv/inky/bin/activate
FLASK_APP=scoreboard FLASK_ENV=development flask run --host=z2a.local --port=5000
