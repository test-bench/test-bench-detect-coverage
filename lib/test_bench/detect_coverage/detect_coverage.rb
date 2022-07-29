module TestBench
  class DetectCoverage
    attr_reader :paths
    attr_reader :run_arguments

    def initialize(paths, run_arguments)
      @paths = paths
      @run_arguments = run_arguments
    end

    def self.build(path, *additional_paths, **run_arguments)
      paths = [path, *additional_paths]

      new(paths, run_arguments)
    end

    def self.call(path, *additional_paths, **run_arguments, &block)
      instance = build(path, *additional_paths, **run_arguments)
      instance.(&block)
    end

    def call(&block)
      reader, writer = IO.pipe

      child_process = fork do
        reader.close

        output = Output.new

        session = TestBench::Session.build(output:)

        TestBench::Run.(session: session, **run_arguments) do |run|
          actuator = proc {
            paths.each do |path|
              run.path(path)
            end
          }

          Trace.(actuator) do |method_specifier|
            if method_specifier.start_with?(TestBench::DetectCoverage.name)
              next
            end

            test_file = output.current_test_file

            text = [
              method_specifier,
              test_file
            ].join("\t")

            writer.puts(text)
          end

          writer.puts

        ensure
          writer.close
        end
      end

      writer.close

      until reader.eof?
        text = reader.gets.chomp

        break if text.empty?

        method_specifier, test_file = text.split("\t", 2)

        invocation = Invocation.new(method_specifier, test_file)

        block.(invocation)
      end

      Process.wait(child_process)
    end

    Invocation = Struct.new(:method_specifier, :test_file) do
      def method = method_specifier
    end

    class Output
      include TestBench::Fixture::Output

      attr_accessor :current_test_file

      def enter_file(path)
        self.current_test_file = path
      end
    end
  end
end
