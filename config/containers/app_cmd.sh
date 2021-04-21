#!/usr/bin/env bash

exec bundle exec unicorn -c config/containers/unicorn.rb -E production
# exec bundle exec unicorn -E production -c config/containers/unicorn.rb