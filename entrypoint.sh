#!/bin/bash

cd /usr/src/app

sleep 10

nodejs seeds/seed.js

nodejs app.js
