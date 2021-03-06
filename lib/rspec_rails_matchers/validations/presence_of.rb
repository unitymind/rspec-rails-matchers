module RspecRailsMatchers
  module Validations
    module PresenceOf
      def validate_presence_of(attribute)
        Rspec::Matchers::Matcher.new :validate_presence_of, attribute do |_attr_|
          match do |model|
            model.class.validators.detect(Proc.new {false}) { |v| v.to_s.demodulize =~ /^PresenceValidator/ &&
                v.attributes.include?(_attr_) }
          end

          failure_message_for_should do |model|
            RspecRailsMatchers::Message.error(
              :expected => [ "%s to validate presence of %s", model, _attr_ ]
            )
          end
        end
      end
    end
  end
end
