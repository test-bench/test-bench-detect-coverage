module TestBench
  class DetectCoverage
    module Controls
      module Receiver
        def self.example
          Class::Example.build
        end

        module Module
          def self.example
            Example
          end

          module Example
            def some_module_instance_method
            end

            def self.some_module_class_method
            end

            class << Example
              def some_module_singleton_method
              end
            end
          end
        end

        module Class
          def self.example
            Example
          end

          class Example
            include Module::Example

            def self.build
              instance = new

              class << instance
                def some_singleton_method
                end
              end

              instance
            end

            def some_instance_method
            end

            def self.some_class_method
            end

            class << self
              def some_singleton_class_method
              end
            end
          end
        end

        module Internal
          def self.example
            Dir
          end

          def self.method_id
            :[]
          end
        end

        module External
          def self.example
            Receiver.example
          end

          def self.local_directory
            '/tmp'
          end

          def self.method_id
            :some_instance_method
          end

          module Gem
            def self.example
              ::TestBench
            end

            def self.method_id
              :session
            end
          end
        end
      end
    end
  end
end
