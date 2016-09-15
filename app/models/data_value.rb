# == Schema Information
#
# Table name: data_values
#
#  id              :integer          not null, primary key
#  type            :integer
#  value           :decimal(19, 4)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  data_type_id    :integer          not null
#  project_year_id :integer          not null
#  formula_value   :decimal(19, 4)
#  input_formula   :string
#
# Indexes
#
#  index_data_values_on_data_type_id  (data_type_id)
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

  def formula
    self.input_formula.blank? ? data_type.formula : self.input_formula
  end

  def get_value
    self.value ? self.value : self.formula_value
  end
end
