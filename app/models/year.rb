# == Schema Information
#
# Table name: years
#
#  id         :integer          not null, primary key
#  year       :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Year < ActiveRecord::Base
  has_many :project_years, dependent: :destroy

  validates :year, uniqueness: true
  validates :year, numericality: { only_integer: true, greater_than: 0, less_than: 10_000 }

  def create_project_years
    Project.all.each do |project|
      project_year = ProjectYear.create(project: project, year: self)
      DataType.all.each do |data_type|
        project_year.create_data_value_for_data_type data_type
      end
    end
  end
end
