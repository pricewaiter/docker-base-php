#!/bin/bash

docker build -t temp_memcached  -f Dockerfile.build .

id=$(docker create temp_memcached)
# docker cp $id:path - > local-tar-file

docker cp $id:/usr/lib/php/modules/memcached.so - | tar xf - > memcached.so
docker cp $id:/usr/lib/libmemcached.so.11 - | tar -xf - > libmemcached.so.11

docker rm -v $id
