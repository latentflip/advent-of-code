#!/bin/bash

source .env
echo $COOKIE

for i in $(seq 1 25); do
    if [ ! -f ./files/$i.txt ]; then
        curl "https://adventofcode.com/2015/day/$i/input" \
            -H 'authority: adventofcode.com' \
            -H 'pragma: no-cache' \
            -H 'cache-control: no-cache' \
            -H 'upgrade-insecure-requests: 1' \
            -H 'user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/70.0.3538.110 Safari/537.36' \
            -H 'accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8' \
            -H "referer: https://adventofcode.com/2015/day/$i" \
            -H 'accept-encoding: gzip, deflate, br' \
            -H 'accept-language: en-US,en;q=0.9' \
            -H "cookie: session=$COOKIE" --compressed \
            > ./files/$i.txt
    fi
done

