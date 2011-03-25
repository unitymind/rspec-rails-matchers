module RspecRailsMatchers
  module Validations
    module ConfirmationOf
      def validate_confirmation_of(attribute)
        Rspec::Matchers::Matcher.new :validate_confirmation_of, attribute do |_attr_|
          match do |model|
            model.class.validators.detect(Proc.new {false}) { |v| v.to_s.demodulize =~ /^ConfirmationValidator/ &&
                v.attributes.include?(_attr_) }
          end

          failure_message_for_should do |model|
            RspecRailsMatchers::Message.error(
              :expected => [ "%s to validate confirmation of %s", model, _attr_ ]
            )
          end
        end
      end
    end
  end
end
