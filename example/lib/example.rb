module Example
  class SomeClass
    def self.build
      instance = new

      class << instance
        def yet_another_method
          SomeGem.some_library_method
        end
      end

      instance
    end

    def self.some_class_method
      instance = build
      instance.some_method
    end

    def some_method
      other_method
    end

    def other_method
      yet_another_method
    end

    def yet_another_method
      raise NotImplementedError
    end
  end
end
