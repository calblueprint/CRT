# == Schema Information
#
# Table name: projects
#
#  id                   :integer          not null, primary key
#  name                 :string
#  acres                :integer
#  date_closed          :date
#  restricted_endowment :decimal(, )
#  cap_rate             :decimal(, )
#  admin_rate           :decimal(, )
#  total_upfront        :decimal(, )
#  years_upfront        :integer
#  earnings_begin       :date
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  general              :boolean          default(FALSE)
#
# Indexes
#
#  index_projects_on_general  (general)
#

class Project < ActiveRecord::Base
  scope :specific_projects, -> { where(general: false) }

  has_many :project_years, dependent: :destroy

  validate :no_other_general_project, if: :general?

  # "General" project will contain general overview information about ranges.
  # This project will contain specific attributes unrelated to other projects.
  def self.general_project
    find_by general: true
  end

  def self.create_data_type_for_specific_projects(data_type)
    specific_projects.each do |specific_project|
      specific_project.create_data_type data_type
    end
  end

  def create_data_type(data_type)
    project_years.each do |project_year|
      project_year.create_data_value_for_data_type data_type
    end
  end

  private

  def no_other_general_project
    general_projects = Project.where(general: true)
    general_projects.delete(self)
    errors.add(:general, 'project already exists') unless general_projects.size == 0
  end
end
