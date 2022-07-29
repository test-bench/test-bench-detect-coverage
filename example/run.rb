#!/usr/bin/env ruby

require_relative './init'

puts <<~TEXT

Detecting Coverage
= = =
TEXT

Dir.chdir(__dir__) do
  TestBench::DetectCoverage.('test/automated') do |invocation|
    puts "- Test #{invocation.test_file} invoked #{invocation.method}"
  end
end

puts
