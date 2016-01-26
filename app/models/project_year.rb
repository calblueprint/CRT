# == Schema Information
#
# Table name: project_years
#
#  id         :integer          not null, primary key
#  date       :date
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  project_id :integer
#  year_id    :integer
#
# Indexes
#
#  index_project_years_on_project_id  (project_id)
#
# Foreign Keys
#
#  fk_rails_e7127774f7  (project_id => projects.id)
#

class ProjectYear < ActiveRecord::Base
  scope :specific, -> { where.not(project: Project.general_project) }

  belongs_to :project
  belongs_to :year
  has_many :data_values, dependent: :destroy

  def create_data_value_for_data_type(data_type)
    DataValue.create value: 0.0, project_year: self, data_type: data_type
  end
end
