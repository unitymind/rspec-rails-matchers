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
              options_unfrozen = validator.options.dup.delete_if { |k| [:if, :unless].include? k}
              actual_options = options_unfrozen
              options_unfrozen.deep_include?(options) && options_unfrozen.keys.sort == options.keys.sort
            end
          end

          failure_message_for_should do |model|
            RspecRailsMatchers::Message.error(
              :expected => [ "%s should validate uniqueness of %s with %s", model, _attr_, options ],
              :actual   => [ "%s has validate uniqueness of %s with %s", model, _attr_, actual_options]
            )
          end
        end
      end
    end
  end
end
