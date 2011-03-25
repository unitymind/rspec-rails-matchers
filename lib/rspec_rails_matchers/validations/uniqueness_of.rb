module RspecRailsMatchers
  module Validations
    module UniquenessOf
      def validate_uniqueness_of(attribute, options = {})
        Rspec::Matchers::Matcher.new :validate_uniqueness_of, attribute do |_attr_|
          options[:case_sensitive] = true if options[:case_sensitive].nil?
          actual_options = {}
          match do |model|
            if validator = model.class.validators.find(Proc.new {false}) { |v| v.to_s.demodulize =~ /^UniquenessValidator/ &&
                v.attributes.include?(_attr_) }
              actual_options = validator.options
              validator.options.deep_include?(options) && validator.options.keys.sort == options.keys.sort
            end
          end

          failure_message_for_should do |model|
            RspecRailsMatchers::Message.error(
              :expected => [ "%s to validate uniqueness of %s, %s", model, _attr_, options ],
              :actual   => [ "%s to validate uniqueness of %s, %s", model, _attr_, actual_options]
            )
          end
        end
      end
    end
  end
end
