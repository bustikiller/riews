module Riews
  class ActionLink < ApplicationRecord
    PARAMETER_REGEX = /\/\(?\:\w+\)?/.freeze
    OPTIONAL_PARAMETER_REGEX = /\(\:\w+\)/

    belongs_to :riews_column, class_name: 'Riews::Column'
    alias_method :column, :riews_column
    alias_method :column=, :riews_column=

    has_many :arguments, as: :argumentable, inverse_of: :argumentable, dependent: :destroy
    accepts_nested_attributes_for :arguments, reject_if: :all_blank, allow_destroy: true

    validates_presence_of :base_path, :display_pattern
    validate :validate_number_of_parameters

    def self.http_verbs
      {
          get: {code: 0, name: 'GET'},
          delete: {code: 1, name: 'DELETE'}
      }
    end

    def base_path_with_replacements(original_row=[])
      arguments.inject(base_path) do |base, argument|
        rendered_argument_value = Riews::ColumnPattern.new(argument.value).format(original_row)
        base.sub(PARAMETER_REGEX, "/#{rendered_argument_value}")
      end.gsub(OPTIONAL_PARAMETER_REGEX, '')
    end

    def delete_link?
      http_verb == self.class.http_verbs[:delete][:code]
    end

    private


    def validate_number_of_parameters
      if base_path
        total_parameter_count = base_path.scan(PARAMETER_REGEX).size
        optional_parameter_count = base_path.scan(OPTIONAL_PARAMETER_REGEX).size

        min_parameter_count = total_parameter_count - optional_parameter_count
        max_parameter_count = total_parameter_count

        current_parameters_count = (arguments).size
        unless current_parameters_count.between?(min_parameter_count, max_parameter_count)
          message = if optional_parameter_count == 0
                      "The number of parameters must be #{total_parameter_count}, was #{ current_parameters_count }"
                    else
                      "The number of parameters must be between #{min_parameter_count} and #{max_parameter_count}, was #{ current_parameters_count }"
                    end
          errors.add(:base, message)
        end
      end
    end
  end
end
