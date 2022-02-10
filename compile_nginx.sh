#!/bin/bash

docker build -t nginx_static .

docker run --rm -v ${PWD}/nginx:/nginx -it nginx_static

