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
#  master               :boolean          default(FALSE)
#
# Indexes
#
#  index_projects_on_master  (master)
#

class Project < ActiveRecord::Base
  scope :specific_projects, -> { where(master: false) }

  has_many :project_years, dependent: :destroy

  validate :no_other_master_project, if: :master?
  validates :name, presence: true, uniqueness: true
  validates :acres, presence: true, numericality: { greater_than_or_equal_to: 0 }

  validates :date_closed, presence: true
  validates :restricted_endowment, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :cap_rate, presence: true, numericality: { greater_than_or_equal_to: 0,
                                                       less_than_or_equal_to: 100 }
  validates :admin_rate, presence: true, numericality: { greater_than_or_equal_to: 0,
                                                         less_than_or_equal_to: 100 }
  validates :total_upfront, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :years_upfront, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :earnings_begin, presence: true

  # "master" project will contain master overview information about ranges.
  # This project will contain specific attributes unrelated to other projects.
  def self.master_project
    find_by master: true
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

  def no_other_master_project
    master_projects = Project.where(master: true)
    master_projects.delete(self)
    errors.add(:master, 'project already exists') unless master_projects.size == 0
  end
end
