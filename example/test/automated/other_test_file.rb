require_relative '../test_init'

context "Other Context" do
  object = Example::SomeClass.build
  object.some_method
end
