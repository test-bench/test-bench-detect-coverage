require_relative '../init'

require_relative 'lib/example'

require 'rbconfig'
require_relative "gems/ruby/#{RbConfig::CONFIG['ruby_version']}/gems/some_gem-1.0.0/lib/some_gem"
