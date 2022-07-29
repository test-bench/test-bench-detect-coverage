#!/bin/sh

ruby \
  --disable-gems \
  --disable-frozen-string-literal \
  -r./test/test_init.rb \
  -e 'TestBench::CLI.()' \
  $@
