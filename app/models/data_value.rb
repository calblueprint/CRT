# == Schema Information
#
# Table name: data_values
#
#  id              :integer          not null, primary key
#  type            :integer
#  value           :decimal(, )
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  data_type_id    :integer          not null
#  project_year_id :integer          not null
#  formula_value   :decimal(, )
#
# Indexes
#
#  index_data_values_on_data_type_id  (data_type_id)
#
# Foreign Keys
#
#  fk_rails_85ef6e85c5  (data_type_id => data_types.id)
#

class DataValue < ActiveRecord::Base
  scope :sort_by_year, -> { joins(:project_year).order('project_years.date') }
  scope :sort_by_data_type, -> { joins(:data_type).order('data_types.order') }

  belongs_to :project_year
  belongs_to :data_type
  has_one :project, through: :project_year
  has_one :year, through: :project_year

  validates :data_type, :project_year, presence: true

  delegate :master?, to: :project

  def previous_data_value
    DataValue.find_by(project_year: project_year.previous_project_year, data_type: data_type)
  end
end
