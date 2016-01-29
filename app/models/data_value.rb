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
#
# Indexes
#
#  index_data_values_on_data_type_id  (data_type_id)
#

class DataValue < ActiveRecord::Base
  belongs_to :project_year
  belongs_to :data_type
  has_one :project, through: :project_year
  has_one :year, through: :project_year

  validates :data_type, :project_year, presence: true

  delegate :general?, to: :project
end
