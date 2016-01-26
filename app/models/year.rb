# == Schema Information
#
# Table name: years
#
#  id         :integer          not null, primary key
#  year       :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Year < ActiveRecord::Base
  has_many :project_years

  def create_project_years
    Project.all.each do |project|
      project_year = ProjectYear.create(project: project, year: self)
      DataType.all.each do |data_type|
        project_year.create_data_value_for_data_type data_type
      end
    end
  end
end
