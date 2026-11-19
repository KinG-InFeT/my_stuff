#!/usr/bin/env python3
"""Turn Yaru-dark CSS/SVG/PNG into the DarkRedHack look (palette.css): recolor and square the corners.

  recolor.py < in.css > out.css     filter for CSS and SVG text
  recolor.py --png FILE...          rewrite PNG images in place

  - greys    -> darker, slightly cool greys
  - orange   -> palette red (Yaru's orange becomes exactly drh_red)
  - yellow   -> palette amber
  - green    -> palette green
  - corners: every radius (px, %, SVG rx/ry) capped at MAX_RADIUS px, so 0 squares circles and pills too
"""
import colorsys
import re
import sys
from functools import cache
from pathlib import Path

GREY_HUE, GREY_SAT = 228 / 360, 0.07
MAX_RADIUS = 0
YARU_ACCENT = "e95420"

# Yaru lightness -> DarkRedHack lightness: much darker surfaces, text kept readable.
LIGHTNESS_CURVE = [(0, 0), (0.30, 0.18), (0.55, 0.54), (0.97, 0.91), (1, 1)]

HEX_RE = re.compile(r"#([0-9a-fA-F]{6}|[0-9a-fA-F]{3})(?![\w-])")
RGB_RE = re.compile(r"(rgba?\(\s*)(\d+)\s*,\s*(\d+)\s*,\s*(\d+)")
RADIUS_RE = re.compile(r"([a-z-]*radius\s*:\s*)([^;}]+)")
LENGTH_RE = re.compile(r"(\d*\.?\d+)(px|%|r?em|pt)")
SVG_RADIUS_RE = re.compile(r'\b(r[xy])="(\d*\.?\d+)"')


def hex_to_hls(value):
    return colorsys.rgb_to_hls(*(int(value[i:i + 2], 16) / 255 for i in (0, 2, 4)))


PALETTE = (Path(__file__).parent / "palette.css").read_text()
RED, AMBER, GREEN = (
    hex_to_hls(re.search(rf"@define-color {name} #([0-9a-f]{{6}});", PALETTE).group(1))
    for name in ("drh_red", "drh_amber", "drh_green")
)
RED_LIGHTNESS_SCALE = RED[1] / hex_to_hls(YARU_ACCENT)[1]


def map_lightness(lightness):
    for (x0, y0), (x1, y1) in zip(LIGHTNESS_CURVE, LIGHTNESS_CURVE[1:]):
        if lightness <= x1:
            return y0 + (lightness - x0) * (y1 - y0) / (x1 - x0)
    return lightness


@cache
def map_rgb(r, g, b):
    h, lightness, s = colorsys.rgb_to_hls(r / 255, g / 255, b / 255)
    degrees = h * 360
    if s < 0.08:
        h, s, lightness = GREY_HUE, GREY_SAT, map_lightness(lightness)
    else:
        if degrees < 30 or degrees >= 340:
            h = RED[0]
            if s >= 0.5:
                s, lightness = RED[2], min(lightness * RED_LIGHTNESS_SCALE, 1)
        elif degrees < 60:
            h = AMBER[0]
        elif 75 <= degrees < 175:
            h = GREEN[0]
        if s < 0.5:  # accent-tinted surfaces: darken like the greys
            lightness = map_lightness(lightness)
    return tuple(round(c * 255) for c in colorsys.hls_to_rgb(h, lightness, s))


def replace_hex(match):
    value = match.group(1)
    if len(value) == 3:
        value = "".join(c * 2 for c in value)
    return "#%02x%02x%02x" % map_rgb(*(int(value[i:i + 2], 16) for i in (0, 2, 4)))


def replace_rgb(match):
    r, g, b = map_rgb(*(int(match.group(i)) for i in (2, 3, 4)))
    return f"{match.group(1)}{r}, {g}, {b}"


def cap_length(match):
    value = float(match.group(1)) if match.group(2) == "px" else MAX_RADIUS
    return f"{min(value, MAX_RADIUS):g}px"


def replace_radius(match):
    return match.group(1) + LENGTH_RE.sub(cap_length, match.group(2))


def replace_svg_radius(match):
    return f'{match.group(1)}="{min(float(match.group(2)), MAX_RADIUS):g}"'


def recolor_text():
    for line in sys.stdin:
        line = HEX_RE.sub(replace_hex, line)
        line = RGB_RE.sub(replace_rgb, line)
        line = RADIUS_RE.sub(replace_radius, line)
        line = SVG_RADIUS_RE.sub(replace_svg_radius, line)
        sys.stdout.write(line)


def recolor_png(paths):
    from PIL import Image

    for path in paths:
        with Image.open(path) as source:
            image = source.convert("RGBA")
        image.putdata([(*map_rgb(r, g, b), a) for r, g, b, a in image.getdata()])
        image.save(path)


if __name__ == "__main__":
    if sys.argv[1:2] == ["--png"]:
        recolor_png(sys.argv[2:])
    else:
        recolor_text()
