# -*- encoding: utf-8 -*-
Gem::Specification.new do |s|
  s.name = 'test_bench-detect_coverage'
  s.version = '0.0.0.0'

  s.authors = ['Nathan Ladd']
  s.email = 'nathanladd+github@gmail.com'
  s.homepage = 'https://github.com/test-bench/test-bench-detect-coverage'
  s.licenses = %w(MIT)
  s.summary = "Capture method invocations caused by TestBench tests"
  s.platform = Gem::Platform::RUBY

  s.require_paths = %w(lib)
  s.files = Dir.glob 'lib/**/*'

  s.bindir = 'script'

  s.add_runtime_dependency 'test_bench'

  s.add_development_dependency 'test_bench-isolated'
end
