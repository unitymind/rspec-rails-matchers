require 'rspec'
require 'rspec/matchers'

$LOAD_PATH.unshift(File.expand_path('../', __FILE__))

module RspecRailsMatchers
  autoload :Message,      'rspec_rails_matchers/message'
  autoload :Validations,  'rspec_rails_matchers/validations'
  autoload :Associations, 'rspec_rails_matchers/associations'
  autoload :Behavior,     'rspec_rails_matchers/behavior'
  autoload :Sugar,        'rspec_rails_matchers/sugar'
end

Rspec.configure do |c|
  c.include RspecRailsMatchers::Validations
  c.include RspecRailsMatchers::Associations
  c.include RspecRailsMatchers::Behavior
  c.include RspecRailsMatchers::Sugar
end

class Hash
  def deep_include?(sub_hash)
    sub_hash.keys.all? do |key|
      self.has_key?(key) && if sub_hash[key].is_a?(Hash)
        self[key].is_a?(Hash) && self[key].deep_include?(sub_hash[key])
      else
        self[key] == sub_hash[key]
      end
    end
  end
end
