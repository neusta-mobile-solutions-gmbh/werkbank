#!/bin/bash

inkscape --help >/dev/null 2>/dev/null
if [ $? -ne 0 ]; then
    echo "Inkscape is not installed. Please install it first."
    exit 1
fi
svgcleaner --help >/dev/null 2>/dev/null
if [ $? -ne 0 ]; then
    echo "svgcleaner is not installed. Please install it first."
    exit 1
fi
cp -r icons_raw icons
cd icons
echo "Renaming SVG files..."
for f in *.svg; do mv "$f" "${f/Icon=/}"; done
echo "Converting paths in inkscape..."
find . -name "*.svg" -exec inkscape --actions="select-all:all;object-stroke-to-path;path-union" --export-filename={} {} \;
echo "Cleaning up SVG files..."
find . -name "*.svg" -exec svgcleaner {} {} \;
cd ..
echo "Generating icon font..."
fvm dart run icon_font_generator:generator
rm -rf icons
echo "Done."
