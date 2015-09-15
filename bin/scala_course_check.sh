#!/bin/bash

URL='http://www.artima.com/shop/stairway_to_scala'

if ! /usr/bin/curl -s $URL | /usr/bin/diff scala_course_now.txt - >/dev/null;then
    echo "<html><body>Something changed on <a href='$URL'>$URL</a>" | /usr/bin/email  -s "scala course" "$(/usr/bin/whoami)@stumbleupon.com"
fi
