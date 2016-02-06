class ProjectYearSerializer < ActiveModel::Serializer
  attributes :project_id, :year_id, :date, :sorted_data_values
end
