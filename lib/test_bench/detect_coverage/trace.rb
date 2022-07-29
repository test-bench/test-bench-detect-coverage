module TestBench
  class DetectCoverage
    class Trace
      attr_reader :actuator
      attr_reader :probe
      attr_reader :local_directory

      def initialize(actuator, probe, local_directory)
        @actuator = actuator
        @probe = probe
        @local_directory = local_directory
      end

      def self.build(actuator, local_directory: nil, &probe)
        local_directory ||= Dir.pwd

        new(actuator, probe, local_directory)
      end

      def self.call(...)
        instance = build(...)
        instance.()
      end

      def call
        trace = TracePoint.trace(:call) do |trace_point|
          trace_point(trace_point)
        end

        actuator.()
      ensure
        trace.disable
      end

      def trace_point(trace_point)
        if internal?(trace_point)
          return
        elsif external?(trace_point)
          return
        end

        path = trace_point.path

        cls = trace_point.defined_class

        if cls.singleton_class?
          receiver = trace_point.self

          if receiver.is_a?(Module)
            cls = trace_point.self

            scope_symbol = '.'
          else
            cls = trace_point.self.class

            scope_symbol = '#'
          end
        else
          scope_symbol = '#'
        end

        constant_name = cls.name

        method_specifier = [
          constant_name,
          scope_symbol,
          trace_point.method_id
        ].join

        probe.(method_specifier)
      end

      def internal?(trace_point)
        path = trace_point.path

        self.class.internal_path_pattern.match?(path)
      end

      def self.internal_path_pattern
        %r{\A<internal:[[:graph:]]+>\z}
      end

      def external?(trace_point)
        path = trace_point.path

        gem_path = File.fnmatch?(self.class.gem_path_pattern, path)
        if gem_path
          return true
        end

        external_path = !path.start_with?(local_directory)
        if external_path
          return true
        end

        false
      end

      def self.gem_path_pattern
        ruby_version = RbConfig::CONFIG['ruby_version']

        File.join('**', 'gems', 'ruby', ruby_version, 'gems', '**')
      end
    end
  end
end
