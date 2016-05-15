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

class ProjectYear < ActiveRecord::Base
  scope :specific, -> { where.not(project: Project.master_project) }

  belongs_to :project
  belongs_to :year

  has_many :data_values, dependent: :destroy

  validates :project, :year, presence: true
  validates :date, uniqueness: { scope: :project },
                   numericality: {
                     greater_than_or_equal_to: 1998, # 1998 is start year for CRT
                     less_than_or_equal_to: Time.now.year
                   },
                   presence: true
  delegate :master, to: :project

  def create_data_value_for_data_type(data_type)
    DataValue.create value: nil, project_year: self, data_type: data_type
  end

  def previous_project_year
    ProjectYear.find_by(year: year.previous_year, project: project)
  end

  def sorted_data_values
    data_values.sort_by_data_type
  end

  def associate_year
    update(year: Year.find_or_create_by(year: date))
  end

  def create_data_values_on_project_year_create
    DataType.where(master: master).each do |data_type|
      value = 0
      if data_type.formula?
        DataValue.create formula_value: value, project_year: self, data_type: data_type
      else
        DataValue.create value: value, project_year: self, data_type: data_type
      end
    end
  end
end
