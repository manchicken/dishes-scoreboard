#!/usr/bin/env python3

import os
import time
from datetime import date
import json
import time
# import fs

from font_fredoka_one import FredokaOne
from inky.auto import auto
from PIL import Image, ImageDraw, ImageFont

__STATE_FILE__="/tmp/scoreboard.state"

def init():
    # Set up the display
    try:
        inky_display = auto(ask_user=True, verbose=True)
    except TypeError:
        raise TypeError("You need to update the Inky library to >= v1.1.0")

    print(inky_display.resolution)
    if inky_display.resolution not in ((212, 104), (250, 122)):
        w, h = inky_display.resolution
        raise RuntimeError("This example does not support {}x{}".format(w, h))

    # Border
    inky_display.set_border(inky_display.BLACK)
    return inky_display

def draw_message(inky_display, main:str, last_updated:str):
    # Image object
    img = Image.new("P", (inky_display.WIDTH, inky_display.HEIGHT))
    draw = ImageDraw.Draw(img)

    # Main font
    main_font = ImageFont.truetype(FredokaOne, 42)

    # Draw the main content
    _, _, w, h = main_font.getbbox(main)
    x = (inky_display.WIDTH / 2) - (w / 2)
    y = (inky_display.HEIGHT / 2) - (h / 2)
    draw.text((x, y), main, inky_display.BLACK, main_font)

    # Draw the date
    date_font = ImageFont.truetype(FredokaOne, 18)

    # Draw the last updated content
    _, _, w, h = date_font.getbbox(last_updated)
    x = (inky_display.WIDTH / 2) - (w / 2)
    y = (inky_display.HEIGHT) - h # At the bottom of the display
    draw.text((x, y), last_updated, inky_display.RED, date_font)


    # Perform the render!
    inky_display.set_image(img)
    inky_display.show()

def update_scoreboard(display, nights:int, last_updated:str):
    night_str = f"{nights} Night"
    if nights != 1:
        night_str += "s"

    draw_message(display, night_str, f"Last updated: {last_updated}")

def fetch_state():
    nights = 0
    last_updated = "never"
    try:
        with open(__STATE_FILE__, mode="r") as fh:
            nights = fh.read()
            fh.close()
            res = os.stat(__STATE_FILE__)
            last_updated = date.fromtimestamp(res.st_mtime).isoformat()
    except FileNotFoundError:
        pass

    return nights, last_updated

def main():
    inky_display = init()
    draw_message(inky_display, "Loading...", "Please wait")
    nights, last_updated = fetch_state()
    # time.sleep(30)
    update_scoreboard(inky_display, nights, last_updated)

if __name__ == "__main__":
    main()
