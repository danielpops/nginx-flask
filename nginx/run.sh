#!/bin/bash

echo "Starting nginx..."
nginx
tail -f /var/log/nginx/*
