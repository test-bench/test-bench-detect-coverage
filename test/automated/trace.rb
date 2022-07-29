require_relative 'automated_init'

context "Trace" do
  context "Instance Method" do
    receiver = Controls::Receiver.example

    instance_method = receiver.method(:some_instance_method)
    control_method_specifier = "#{receiver.class}#some_instance_method"

    method_specifiers = []
    DetectCoverage::Trace.(instance_method) do |method_specifier|
      method_specifiers << method_specifier
    end

    test! do
      assert(method_specifiers.one?)
    end

    context "Specifier" do
      method_specifier = method_specifiers.first

      comment method_specifier
      detail "Control: #{control_method_specifier}"

      test do
        assert(method_specifier == control_method_specifier)
      end
    end
  end

  context "Class Method" do
    receiver = Controls::Receiver::Class.example

    class_method = receiver.method(:some_class_method)
    control_method_specifier = "#{receiver}.some_class_method"

    method_specifiers = []
    DetectCoverage::Trace.(class_method) do |method_specifier|
      method_specifiers << method_specifier
    end

    test! do
      assert(method_specifiers.one?)
    end

    context "Specifier" do
      method_specifier = method_specifiers.first

      comment method_specifier
      detail "Control: #{control_method_specifier}"

      test do
        assert(method_specifier == control_method_specifier)
      end
    end
  end

  context "Singleton Method" do
    receiver = Controls::Receiver.example

    singleton_method = receiver.method(:some_singleton_method)
    control_method_specifier = "#{receiver.class}#some_singleton_method"

    method_specifiers = []
    DetectCoverage::Trace.(singleton_method) do |method_specifier|
      method_specifiers << method_specifier
    end

    test! do
      assert(method_specifiers.one?)
    end

    context "Specifier" do
      method_specifier = method_specifiers.first

      comment method_specifier
      detail "Control: #{control_method_specifier}"

      test do
        assert(method_specifier == control_method_specifier)
      end
    end
  end

  context "Class Singleton Method" do
    receiver = Controls::Receiver::Class.example

    class_singleton_method = receiver.method(:some_singleton_class_method)
    control_method_specifier = "#{receiver}.some_singleton_class_method"

    method_specifiers = []
    DetectCoverage::Trace.(class_singleton_method) do |method_specifier|
      method_specifiers << method_specifier
    end

    test! do
      assert(method_specifiers.one?)
    end

    context "Specifier" do
      method_specifier = method_specifiers.first

      comment method_specifier
      detail "Control: #{control_method_specifier}"

      test do
        assert(method_specifier == control_method_specifier)
      end
    end
  end

  context "Module Instance Method" do
    receiver = Controls::Receiver.example

    module_instance_method = receiver.method(:some_module_instance_method)
    control_method_specifier = "#{Controls::Receiver::Module::Example}#some_module_instance_method"

    method_specifiers = []
    DetectCoverage::Trace.(module_instance_method) do |method_specifier|
      method_specifiers << method_specifier
    end

    test! do
      assert(method_specifiers.one?)
    end

    context "Specifier" do
      method_specifier = method_specifiers.first

      comment method_specifier
      detail "Control: #{control_method_specifier}"

      test do
        assert(method_specifier == control_method_specifier)
      end
    end
  end

  context "Module Class Method" do
    receiver = Controls::Receiver::Module.example

    module_class_method = receiver.method(:some_module_class_method)
    control_method_specifier = "#{receiver}.some_module_class_method"

    method_specifiers = []
    DetectCoverage::Trace.(module_class_method) do |method_specifier|
      method_specifiers << method_specifier
    end

    test! do
      assert(method_specifiers.one?)
    end

    context "Specifier" do
      method_specifier = method_specifiers.first

      comment method_specifier
      detail "Control: #{control_method_specifier}"

      test do
        assert(method_specifier == control_method_specifier)
      end
    end
  end

  context "Module Singleton Method" do
    receiver = Controls::Receiver::Module.example

    module_singleton_method = receiver.method(:some_module_singleton_method)
    control_method_specifier = "#{receiver}.some_module_singleton_method"

    method_specifiers = []
    DetectCoverage::Trace.(module_singleton_method) do |method_specifier|
      method_specifiers << method_specifier
    end

    test! do
      assert(method_specifiers.one?)
    end

    context "Specifier" do
      method_specifier = method_specifiers.first

      comment method_specifier
      detail "Control: #{control_method_specifier}"

      test do
        assert(method_specifier == control_method_specifier)
      end
    end
  end

  context "Internal Ruby Method" do
    receiver = Controls::Receiver::Internal.example

    internal_method_id = Controls::Receiver::Internal.method_id
    internal_method = receiver.method(internal_method_id)

    method_specifiers = []
    DetectCoverage::Trace.(internal_method) do |method_specifier|
      method_specifiers << method_specifier
    end

    test "Ignored" do
      assert(method_specifiers.none?)
    end
  end

  context "External Method" do
    context "Outside Current Directory" do
      receiver = Controls::Receiver::External.example

      local_directory = Controls::Receiver::External.local_directory

      external_method_id = Controls::Receiver::External.method_id
      external_gem_method = receiver.method(external_method_id)

      method_specifiers = []
      DetectCoverage::Trace.(external_gem_method, local_directory:) do |method_specifier|
        method_specifiers << method_specifier
      end

      test "Ignored" do
        assert(method_specifiers.none?)
      end
    end

    context "Gem" do
      receiver = Controls::Receiver::External::Gem.example

      external_gem_method_id = Controls::Receiver::External::Gem.method_id
      external_gem_method = receiver.method(external_gem_method_id)

      method_specifiers = []
      DetectCoverage::Trace.(external_gem_method) do |method_specifier|
        method_specifiers << method_specifier
      end

      test "Ignored" do
        assert(method_specifiers.none?)
      end
    end
  end
end
