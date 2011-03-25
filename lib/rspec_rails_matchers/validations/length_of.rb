module RspecRailsMatchers
  module Validations
    module LengthOf
      def validate_length_of(attribute, options = {})
#        options.assert_valid_keys( :within, :minimum, :maximum )

        # Copy-paste from active_model/validations/length.rb:13
        if range = (options.delete(:in) || options.delete(:within))
          raise ArgumentError, ":in and :within must be a Range" unless range.is_a?(Range)
          options[:minimum], options[:maximum] = range.begin, range.end
          options[:maximum] -= 1 if range.exclude_end?
        end

        if (ActiveModel::Validations::LengthValidator::CHECKS.keys & options.keys).empty?
          raise ArgumentError, 'Range unspecified. Specify the :within, :maximum, :minimum, or :is option.'
        end

        # Not need to check equals of this option's keys.
        # :if, :unless, :tokenize - should be different all time.
        # :too_long, :too_short, :wrong_length - not important for correct validation
        delete_keys = [:tokenizer, :too_long, :too_short, :wrong_length, :message, :if, :unless]
        options.delete_if { |k| delete_keys.include? k }

        actual_options = {}

        Rspec::Matchers::Matcher.new :validate_length_of, attribute do |_attr_|
          match do |model|
            if validator = model.class.validators.find(Proc.new {false}) { |v| v.to_s.demodulize =~ /^LengthValidator/ &&
                v.attributes.include?(_attr_) }
              # Same reason
              options_unfrozen = validator.options.dup
              options_unfrozen.delete_if { |k| delete_keys.include? k }
              actual_options = options_unfrozen
              options_unfrozen.deep_include?(options) && options_unfrozen.keys.sort == options.keys.sort
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
