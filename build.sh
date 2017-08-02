#!/bin/bash

SCRIPT_DIR=`dirname "$0"`

cd $SCRIPT_DIR
docker build --build-arg https_proxy=$http_proxy \
             --build-arg http_proxy=$http_proxy \
             --build-arg HTTPS_PROXY=$https_proxy \
             --build-arg HTTP_PROXY=$http_proxy \
             -t kbanke/meteor-quickstart .
