require_relative '../init'

require 'test_bench/isolated'; TestBenchIsolated::TestBench.activate

require 'test_bench/detect_coverage/controls'

DetectCoverage = TestBench::DetectCoverage
Controls = DetectCoverage::Controls
