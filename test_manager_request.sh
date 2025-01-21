#!/bin/sh
# POST request to start a server
curl -H 'Content-Type: application/json' \
    -d '{ "name":"test-server","list":1, "version": "0.13.0"}' \
    -X POST -k \
    https://localhost/api/manager/request