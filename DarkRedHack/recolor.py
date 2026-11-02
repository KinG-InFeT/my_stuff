#!/usr/bin/env python3
"""Turn Yaru-dark CSS/SVG into the DarkRedHack look (cve.now palette): recolor and square the corners.

Filter: reads stdin, writes stdout.
  - greys    -> darker, slightly cool greys (cve.now surfaces and text)
  - orange   -> cve.now red (#ff0027)
  - yellow   -> cve.now amber (#ffbb00)
  - green    -> cve.now green (#0fd29b)
  - any radius above MAX_RADIUS px -> MAX_RADIUS px (percentages are kept)
"""
import colorsys
import re
import sys

RED_HUE, AMBER_HUE, GREEN_HUE = 351 / 360, 44 / 360, 163 / 360
GREY_HUE, GREY_SAT = 228 / 360, 0.07
MAX_RADIUS = 2

# Yaru lightness -> cve.now lightness: much darker surfaces, text kept readable.
LIGHTNESS_CURVE = [(0, 0), (0.30, 0.18), (0.55, 0.54), (0.97, 0.91), (1, 1)]

HEX_RE = re.compile(r"#([0-9a-fA-F]{6}|[0-9a-fA-F]{3})(?![\w-])")
RGB_RE = re.compile(r"(rgba?\(\s*)(\d+)\s*,\s*(\d+)\s*,\s*(\d+)")
RADIUS_RE = re.compile(r"([a-z-]*radius\s*:\s*)([^;}]+)")
PX_RE = re.compile(r"(\d*\.?\d+)px")


def map_lightness(lightness):
    for (x0, y0), (x1, y1) in zip(LIGHTNESS_CURVE, LIGHTNESS_CURVE[1:]):
        if lightness <= x1:
            return y0 + (lightness - x0) * (y1 - y0) / (x1 - x0)
    return lightness


def map_rgb(r, g, b):
    h, lightness, s = colorsys.rgb_to_hls(r / 255, g / 255, b / 255)
    degrees = h * 360
    if s < 0.08:
        h, s, lightness = GREY_HUE, GREY_SAT, map_lightness(lightness)
    else:
        if degrees < 30 or degrees >= 340:
            h = RED_HUE
            if s >= 0.5:
                s = 1.0
        elif degrees < 60:
            h = AMBER_HUE
        elif 75 <= degrees < 175:
            h = GREEN_HUE
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


def replace_radius(match):
    value = PX_RE.sub(lambda m: f"{min(float(m.group(1)), MAX_RADIUS):g}px", match.group(2))
    return match.group(1) + value


def main():
    for line in sys.stdin:
        line = HEX_RE.sub(replace_hex, line)
        line = RGB_RE.sub(replace_rgb, line)
        line = RADIUS_RE.sub(replace_radius, line)
        sys.stdout.write(line)


if __name__ == "__main__":
    main()
