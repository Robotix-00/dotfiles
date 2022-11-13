#!/bin/sh

volume=$(awk -F"[][]" '/Left:/ { print $2 }' <(amixer sget Master));
setVol="amixer -q set Master"

echo "<action=`` button=1>$volume</action>";
