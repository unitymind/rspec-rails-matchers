module RspecRailsMatchers
  module Validations
    module NumericalityOf
      def validate_numericality_of( attribute, options = {} )
        Rspec::Matchers::Matcher.new :validate_numericality_of, attribute do |_attr_|
          match do |model|
            model.class.validators.detect(Proc.new {false}) { |v| v.to_s.demodulize =~ /^NumericalityValidator/ &&
                v.attributes.include?(_attr_) }
          end

          failure_message_for_should do |model|
            RspecRailsMatchers::Message.error(
              :expected => 
                [ "%s to validate numericality of %s, %s", model, _attr_, options ]
            )
          end
        end
      end
    end
  end
end

