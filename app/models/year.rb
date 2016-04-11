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

  def previous_year
    Year.find_by_year(year - 1)
  end
end
