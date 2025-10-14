module LlmTranslator
  extend ActiveSupport::Concern

  class Translator
    attr_reader :resource, :field

    def initialize(resource, field = nil)
      @resource = resource.to_s
      @field = field.to_s if field
      @config = load_config
    end

    # Main translation methods
    def input(value)
      return nil if value.nil?

      # Get the ID from English value
      field_config = @config.dig(@resource, @field)
      return nil unless field_config

      english_key = value.to_s.downcase
      portuguese_value = field_config['mappings'][english_key]
      return nil unless portuguese_value

      # Find the ID in database
      model_class = field_config['model'].constantize
      attribute = field_config['attribute']

      record = model_class.find_by(attribute => portuguese_value)
      record&.Id
    end

    def output(id)
      return nil if id.nil?

      field_config = @config.dig(@resource, @field)
      return nil unless field_config

      # Find the record by ID
      model_class = field_config['model'].constantize
      attribute = field_config['attribute']

      record = model_class.find_by(Id: id)
      return nil unless record

      # Get Portuguese value and translate to English
      portuguese_value = record.send(attribute)
      pt_to_en = field_config['mappings'].invert
      pt_to_en[portuguese_value] || 'unknown'
    end

    private

    def load_config
      @config ||= YAML.load_file(Rails.root.join('config/llm_translations.yml'))
    end
  end

  # Helper method to create translator instances
  def translation(resource, field = nil)
    Translator.new(resource, field)
  end

  # For backward compatibility and convenience
  module_function :translation
end
