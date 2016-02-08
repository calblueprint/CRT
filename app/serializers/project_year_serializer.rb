# == Schema Information
#
# Table name: project_years
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  project_id :integer          not null
#  year_id    :integer          not null
#  date       :integer
#
# Indexes
#
#  index_project_years_on_project_id  (project_id)
#
# Foreign Keys
#
#  fk_rails_0020e4e94e  (project_id => projects.id)
#

class ProjectYearSerializer < ActiveModel::Serializer
  attributes :project_id, :year_id, :date, :sorted_data_values
end
