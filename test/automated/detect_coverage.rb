require_relative 'automated_init'

context "Detect Coverage" do
  invocations = []

  DetectCoverage.('test/automated', directory: 'example') do |invocation|
    invocations << invocation
  end

  [
    "SomeTestHelper.call",
    "Example::SomeClass.some_class_method",
    "Example::SomeClass.build",
    "Example::SomeClass#some_method",
    "Example::SomeClass#other_method",
    "Example::SomeClass#yet_another_method"
  ].each do |control_method|
    context "#{control_method}" do
      invocation = invocations.shift

      test! do
        refute(invocation.nil?)
      end

      context "Method" do
        method = invocation.method

        comment method.inspect

        test do
          assert(method == control_method)
        end
      end

      context "Test File" do
        test_file = invocation.test_file
        control_test_file = 'example/test/automated/some_test_file.rb'

        comment test_file.inspect
        detail "Control: #{control_test_file.inspect}"

        test do
          assert(test_file == control_test_file)
        end
      end
    end
  end

  context "SomeGem.some_library_method" do
    not_invoked = invocations.empty?

    test "Not invoked" do
      assert(not_invoked)
    end
  end
end
