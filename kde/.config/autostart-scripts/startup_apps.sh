#!/bin/sh

if ! pgrep -x "xbanish" > /dev/null; then
  xbanish &
fi
