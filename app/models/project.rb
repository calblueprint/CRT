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
#

class Project < ActiveRecord::Base
  has_many :years, :dependent => :destroy

  # "General" project will contain general overview information about ranges.
  # This project will contain specific attributes unrelated to other projects.
  def self.general_project_name
    "General"
  end

  # scope that retrieves the general project instance
  def self.general_project
    where(name: Project.general_project_name)[0]
  end

  def general
    name == Project.general_project_name
  end
end
