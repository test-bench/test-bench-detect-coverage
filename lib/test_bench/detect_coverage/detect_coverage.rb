module TestBench
  class DetectCoverage
    def run
      @run ||= Run::Substitute.build
    end
    attr_writer :run

    attr_reader :path

    def initialize(path)
      @path = path
    end

    def self.build(path, session: nil, directory: nil, exclude: nil)
      session ||= Session.build

      if not directory.nil?
        path = ::File.join(directory, path)
      end

      instance = new(path)
      Run.configure(instance, session:, exclude:)
      instance
    end

    def self.call(path, *additional_paths, **, &)
      instance = build(path, *additional_paths, **)
      instance.(&)
    end

    def call(&block)
      reader, writer = IO.pipe

      record_file = RecordFile.new
      run.telemetry.register(record_file)

      child_process = fork do
        reader.close

        run.! do
          Trace.(->{ run << path }) do |method_specifier|
            if method_specifier.start_with?(TestBench::DetectCoverage.name)
              next
            end

            test_file = record_file.current_test_file

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

    class RecordFile
      include TestBench::Telemetry::Sink::Handler
      include TestBench::Run::Events

      attr_accessor :current_test_file

      handle FileStarted do |file_started|
        file = file_started.file

        self.current_test_file = file
      end
    end
  end
end
