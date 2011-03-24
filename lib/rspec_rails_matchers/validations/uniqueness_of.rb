module RspecRailsMatchers
  module Validations
    module UniquenessOf
      def validate_uniqueness_of(attribute, options = {})
        Rspec::Matchers::Matcher.new :validate_uniqueness_of, attribute do |_attr_|
          match do |model|
            model.class.validators.detect(Proc.new {false}) { |v| v.to_s.demodulize =~ /^UniquenessValidator/ &&
                v.attributes.include?(_attr_) && v.options.deep_include?(options) }
          end

          failure_message_for_should do |model|
            RspecRailsMatchers::Message.error(
              :expected => 
                [ "%s to validate uniqueness of %s, %s", model, _attr_, options ]
            )
          end
        end
      end
    end
  end
end
