#!/usr/bin/env bash

# Remove the server pid file in case the server was not shut down nicely
if [ -f /myapp/tmp/pids/server.pid ]; then
    rm /myapp/tmp/pids/server.pid
fi

bin/rails s -p 3000 -b '0.0.0.0'
#bundle exec rdebug-ide --host 0.0.0.0 --port 1234 --dispatcher-port 26162 -- /myapp/bin/rails s -b 0.0.0.0