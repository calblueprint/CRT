# == Schema Information
#
# Table name: project_years
#
#  id         :integer          not null, primary key
#  date       :date
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  project_id :integer          not null
#  year_id    :integer          not null
#
# Indexes
#
#  index_project_years_on_project_id  (project_id)
#

class ProjectYear < ActiveRecord::Base
  scope :specific, -> { where.not(project: Project.general_project) }

  belongs_to :project
  belongs_to :year

  has_many :data_values, dependent: :destroy

  validates :project, :year, presence: true

  def create_data_value_for_data_type(data_type)
    DataValue.create value: 0.0, project_year: self, data_type: data_type
  end
end
