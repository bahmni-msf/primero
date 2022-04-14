# frozen_string_literal: true

# Class to hold SQL results
class ManagedReports::SqlReportIndicator < ValueObject
  include ManagedReports::SqlQueryHelpers

  attr_accessor :params, :data

  QUARTER = 'quarter'
  MONTH = 'month'
  YEAR = 'year'

  class << self
    def sql(current_user, params = {}); end

    def build(current_user = nil, params = {})
      indicator = new(params: params)
      results = indicator.execute_query(current_user)
      indicator.data = block_given? ? yield(results) : build_results(results)
      indicator
    end

    def build_results(results)
      results_array = results.to_a

      return results_array unless results_array.any? { |result| result['group_id'].present? }

      build_groups(results_array)
    end

    def build_groups(results)
      results.each_with_object([]) do |elem, acc|
        group_id = elem.delete('group_id')
        current_group = acc.find { |group| group['group_id'] == group_id }
        if current_group.present?
          current_group['data'] << elem
        else
          acc << { 'group_id' => group_id, 'data' => [elem] }
        end
      end
    end

    def user_scope_query(current_user, table_name = nil)
      return if current_user.blank? || current_user.group_permission?(Permission::ALL)

      if current_user.group_permission?(Permission::AGENCY)
        agency_scope_query(current_user, table_name)
      elsif current_user.group_permission?(Permission::GROUP)
        group_scope_query(current_user, table_name)
      else
        self_scope_query(current_user, table_name)
      end
    end

    def grouped_date_query(grouped_by_param, date_param, table_name = nil)
      return unless grouped_by_param.present? && date_param.present?

      case grouped_by_param.value
      when QUARTER then grouped_quarter_query(date_param, table_name)
      when MONTH then grouped_month_query(date_param, table_name)
      else grouped_year_query(date_param, table_name)
      end
    end
  end

  def execute_query(current_user)
    ActiveRecord::Base.connection.execute(self.class.sql(current_user, params))
  end
end
